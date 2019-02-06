[Setup]
AppId=OpenEstateImmoServer
AppName=OpenEstate-ImmoServer
AppPublisher=OpenEstate.org
AppPublisherURL=https://openestate.org/
AppSupportURL=https://openestate.org/support/tickets
AppUpdatesURL=https://openestate.org/downloads/openestate-immoserver
AppVersion={#VersionNumber}
AppVerName=OpenEstate-ImmoServer {#Version}
AppCopyright=(C) 2009-2019 OpenEstate.org
VersionInfoVersion={#VersionNumber}
VersionInfoTextVersion={#Version}

OutputBaseFilename=OpenEstate-ImmoServer-{#Version}.win64.setup
Compression=lzma2
SolidCompression=no

MinVersion=6.0
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

DefaultDirName={pf}\OpenEstate-ImmoServer
DefaultGroupName=OpenEstate-ImmoServer

Uninstallable=yes
UninstallDisplayIcon={app}\share\icons\ImmoServer.ico

DisableWelcomePage=no
AllowNoIcons=yes

SetupMutex=OpenEstateImmoServerSetup,Global\OpenEstateImmoServerSetup


; [Tasks]
; Name: "desktopicon"; \
;     Description: "{cm:CreateDesktopIcon}"; \
;     GroupDescription: "{cm:AdditionalIcons}"


[Files]
Source: "{#Package}\*"; \
    DestDir: "{app}"; \
    Flags: recursesubdirs


[Icons]
Name: "{group}\{cm:StartImmoServer}"; \
    Filename: "{app}\bin\Start.exe"
Name: "{group}\{cm:Management}\{cm:ManagementSslInit}"; \
    Filename: "{app}\bin\SslInit.exe"
Name: "{group}\{cm:Service}\{cm:ServiceInstall}"; \
    Filename: "{app}\bin\ServiceInstall.bat"
Name: "{group}\{cm:Service}\{cm:ServiceUninstall}"; \
    Filename: "{app}\bin\ServiceUninstall.bat"
Name: "{group}\{cm:Service}\{cm:ServiceStart}"; \
    Filename: "{app}\bin\ServiceStart.bat"
Name: "{group}\{cm:Service}\{cm:ServiceStop}"; \
    Filename: "{app}\bin\ServiceStop.bat"
Name: "{group}\{cm:Service}\{cm:ServiceManage}"; \
    Filename: "{app}\bin\service\OpenEstate-ImmoServer.exe"
Name: "{group}\{cm:UninstallProgram,ImmoServer}"; \
    Filename: "{uninstallexe}"; \
    WorkingDir: "{app}"
; Name: "{commondesktop}\OpenEstate-ImmoServer"; \
;     Filename: "{app}\bin\Start.exe"; \
;     Tasks: desktopicon


[UninstallDelete]
Type: filesandordirs; \
    Name: "{app}\etc\ssl"


[UninstallRun]
Filename: "{app}\bin\ServiceStop.bat"; \
    Parameters: "/q"; \
    WorkingDir: "{app}\bin"; \
    RunOnceId: "StopService"; \
    Flags: runascurrentuser runhidden
Filename: "{app}\bin\ServiceUninstall.bat"; \
    Parameters: "/q"; \
    WorkingDir: "{app}\bin"; \
    RunOnceId: "UninstallService"; \
    Flags: runascurrentuser runhidden


[Languages]
Name: "en"; \
    MessagesFile: "compiler:Default.isl"
Name: "de"; \
    MessagesFile: "compiler:Languages\German.isl"


[CustomMessages]
StartImmoServer=Start ImmoServer in foreground
Management=Management
ManagementSslInit=Create SSL certificate
Service=ImmoServer as a service
ServiceInstall=Install ImmoServer service
ServiceUninstall=Uninstall ImmoServer service
ServiceStart=Start ImmoServer service
ServiceStop=Stop ImmoServer service
ServiceManage=Manage ImmoServer service

de.StartImmoServer=ImmoServer im Vordergrund starten
de.Management=Verwaltung
de.ManagementSslInit=SSL-Zertifikat erzeugen
de.Service=ImmoServer als Dienst
de.ServiceInstall=ImmoServer-Dienst installieren
de.ServiceUninstall=ImmoServer-Dienst deinstallieren
de.ServiceStart=ImmoServer-Dienst starten
de.ServiceStop=ImmoServer-Dienst stoppen
de.ServiceManage=ImmoServer-Dienst verwalten
