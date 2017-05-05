/*
 * Copyright 2009-2017 OpenEstate.org.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.openestate.tool.server;

import java.awt.AWTException;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.TrayIcon;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.InputStream;
import javax.imageio.ImageIO;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.SystemUtils;
import org.hsqldb.server.ServerConfiguration;
import org.hsqldb.server.ServerConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Implementation of OpenEstate-Server.
 *
 * @since 1.0
 * @author Andreas Rudolph
 */
public class Server extends org.hsqldb.Server
{
  private final static Logger LOGGER = LoggerFactory.getLogger( Server.class );
  private static Server server = null;

  public Server()
  {
    super();
  }

  public static Server get()
  {
    return server;
  }

  private static void initSystemTray()
  {
    final String trayEnabled = StringUtils.trimToNull( StringUtils.lowerCase( System.getProperty( "openestate.server.trayIcon", "false" ) ) );
    if (!"1".equals( trayEnabled ) && !"true".equals( trayEnabled ))
      return;

    if (SystemUtils.isJavaAwtHeadless())
      return;

    if (!SystemUtils.IS_OS_WINDOWS)
      return;

    //Check the SystemTray is supported
    if (!SystemTray.isSupported())
    {
      LOGGER.warn( "The system does not support system tray." );
      return;
    }

    final Image trayIconImage;
    try
    {
      trayIconImage = ImageIO.read( Server.class.getResourceAsStream( "/org/openestate/tool/server/resources/ImmoServer.png" ) );
    }
    catch (Exception ex)
    {
      LOGGER.error( "Can't load icon for system tray!" );
      LOGGER.error( "> " + ex.getLocalizedMessage(), ex );
      return;
    }

    final PopupMenu popup = new PopupMenu();
    final MenuItem stopItem = new MenuItem( "Shutdown server." );
    stopItem.addActionListener( new ActionListener()
    {
      @Override
      public void actionPerformed( ActionEvent e )
      {
        stopItem.setEnabled( false );
        server.stop();
      }
    } );
    popup.add( stopItem );

    final TrayIcon trayIcon = new TrayIcon( trayIconImage, "OpenEstate-ImmoServer", popup );
    trayIcon.setImageAutoSize( true );

    final SystemTray tray = SystemTray.getSystemTray();
    try
    {
      tray.add( trayIcon );
    }
    catch (AWTException ex)
    {
      LOGGER.error( "Can't add icon to system tray!" );
      LOGGER.error( "> " + ex.getLocalizedMessage(), ex );
    }
  }

  public static void main( String[] args )
  {
    //org.hsqldb.Server.main( args );

    final ServerProperties props;
    try
    {
      InputStream propsStream = Server.class.getResourceAsStream( "/server.properties" );
      if (propsStream==null)
      {
        LOGGER.error( "Can't find server configuration!" );
        return;
      }
      props = ServerProperties.create( ServerConstants.SC_PROTOCOL_HSQL, propsStream );
    }
    catch (Exception ex)
    {
      LOGGER.error( "Can't load server configuration!" );
      LOGGER.error( "> " + ex.getLocalizedMessage(), ex );
      return;
    }

    ServerConfiguration.translateDefaultDatabaseProperty( props );

    // Standard behaviour when started from the command line
    // is to halt the VM when the server shuts down. This may, of
    // course, be overridden by whatever, if any, security policy
    // is in place.
    ServerConfiguration.translateDefaultNoSystemExitProperty( props );
    ServerConfiguration.translateAddressProperty( props );

    server = new Server();
    try
    {
      server.setProperties( props );
    }
    catch (Exception e)
    {
      server.printError( "Failed to set properties!" );
      server.printStackTrace( e );
      return;
    }

    initSystemTray();
    server.start();
  }

  @Override
  protected void print( String msg )
  {
    //super.print( msg );
    LOGGER.info( "[" + this.getServerId() + "]: " + msg );
  }

  @Override
  protected void printError( String msg )
  {
    //super.printError( msg );
    LOGGER.error( msg );
  }

  @Override
  protected void printStackTrace( Throwable t )
  {
    //super.printStackTrace( t );
    LOGGER.error( t.getLocalizedMessage(), t );
  }

  @Override
  protected void printWithThread( String msg )
  {
    super.printWithThread( msg );
  }
}