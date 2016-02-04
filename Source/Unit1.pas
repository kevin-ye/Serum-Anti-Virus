Unit Unit1;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkinData, DynamicSkinForm, spTrayIcon, SkinExCtrls, ComCtrls,
  SkinCtrls, Menus, ImgList, ExtCtrls, SkinMenus;

Type
  TForm1 = Class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinData1: TspSkinData;
    spCompressedStoredSkin1: TspCompressedStoredSkin;
    spTrayIcon1: TspTrayIcon;
    spSkinButton1: TspSkinButton;
    spSkinMainMenuBar1: TspSkinMainMenuBar;
    spSkinMainMenu1: TspSkinMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    SerumAntiVirusV101: TMenuItem;
    spSkinPanel1: TspSkinPanel;
    spSkinScrollBar1: TspSkinScrollBar;
    spSkinScrollBar2: TspSkinScrollBar;
    spSkinListView1: TspSkinListView;
    ImageList1: TImageList;
    Timer1: TTimer;
    spSkinPopupMenu1: TspSkinPopupMenu;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    Procedure FormCreate(Sender: TObject);
    Procedure WMDeviceChange(Var Msg: TMessage);
    Message WM_DEVICECHANGE;
    Procedure Find(path: String; Var dlist: TStrings);
    Procedure spSkinButton1Click(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
    Procedure spSkinListView1Insert(Sender: TObject; Item: TListItem);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure N4Click(Sender: TObject);
    Procedure N8Click(Sender: TObject);
    Procedure SerumAntiVirusV101Click(Sender: TObject);
    Procedure RandomizeBuffer;
    Function safedel(FileName: String): Boolean;
    procedure N6Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Const
  DBT_DEVICEARRIVAL = $8000; //    system detected a new device
  DBT_DEVICEREMOVECOMPLETE = $8004; // device is gone
  DBT_DEVTYP_VOLUME = $00000002; // logical volume
  DBTF_MEDIA = $0001;

// media comings and goings
Type
  PDEV_BROADCAST_HDR = ^TDEV_BROADCAST_HDR;

  TDEV_BROADCAST_HDR = Packed Record
    dbch_size: DWORD;
    dbch_devicetype: DWORD;
    dbch_reserved: DWORD;
  End;

  PDEV_BROADCAST_VOLUME = ^TDEV_BROADCAST_VOLUME;

  TDEV_BROADCAST_VOLUME = Packed Record
    dbcv_size: DWORD;
    dbcv_devicetype: DWORD;
    dbcv_reserved: DWORD;
    dbcv_unitmask: DWORD;
    dbcv_flags: WORD;
  End;

Var
  Form1: TForm1;
  autorun: Boolean;
  run: Boolean;
  d: TStrings;
  buffer: Array [0 .. 4095] Of Byte;

Implementation

Uses Unit2, Unit3,  Unit5;
{$R *.dfm}

Procedure TForm1.RandomizeBuffer;
Var
  i: Integer;
Begin
  For i := Low(buffer) To High(buffer) Do
    buffer[i] := Random(256);
End;

Function TForm1.safedel(FileName: String): Boolean;//file damaging~~~~~~����
Var
  max, n: LongInt;
  i: Integer;
  fs: TFileStream;
Begin
  Try
    fs := TFileStream.Create(FileName, fmOpenReadWrite Or fmShareExclusive);
    Try
      For i := 1 To 3 Do
      Begin
        RandomizeBuffer;
        max := fs.Size;
        fs.Position := 0;
        While max <> 0 Do
        Begin
          If max = SizeOf(buffer) Then
            n := SizeOf(buffer)
          Else
          Begin
            n := max;
            fs.Write(buffer, n);
            max := max - n;
          End;
          FlushFileBuffers(fs.Handle);
        End;
      End;
    Finally
      fs.Free;
      Deletefile(FileName);
      safedel := true;
    End;
  Except
    safedel := false;
  End;
End;

Procedure TForm1.WMDeviceChange(Var Msg: TMessage);
Var
  lpdb: PDEV_BROADCAST_HDR;
  lpdbv: PDEV_BROADCAST_VOLUME;
  unitmask: DWORD;
  i, c, wx, fc: Integer;
  temp: TListItem;
Begin
  If Not run Then
    Exit;
  lpdb := PDEV_BROADCAST_HDR(Msg.LParam);
  Case Msg.WParam Of
    DBT_DEVICEARRIVAL: // new device
      If lpdb.dbch_devicetype = DBT_DEVTYP_VOLUME Then
      Begin
        lpdbv := PDEV_BROADCAST_VOLUME(lpdb);
        unitmask := lpdbv.dbcv_unitmask; // disk path
        For i := 0 To 25 Do // tree disk
        Begin
          If Boolean(unitmask And $1) Then
            break;
          unitmask := unitmask Shr 1;
        End;
        temp := spSkinListView1.Items.Add;
        temp.Caption := 'Note';
        temp.SubItems.Add(FormatDateTime('cc', Now()));
        temp.SubItems.Add('Checked ' + char(i + 65) + ':\ new device,start scaning.');
        wx := 0;
        fc := 0;
        Form3.spSkinAnimateGauge1.ShowProgressText := false;
        Form3.spSkinAnimateGauge1.StartAnimation;
        Form3.Timer1.Enabled := false;
        Form3.spSkinLabel3.Caption := 'number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'number of virus: ' + inttostr(wx);
        Form3.Show;
        Form3.spSkinLabel1.Caption := 'file path: ' + char(i + 65) + ':\';
        Application.ProcessMessages;
      // Kill Virus
        Find(Chr(65 + i) + ':\', d);
        c := i;
        inc(fc);
        Form3.spSkinLabel2.Caption := 'checking: ' + char(i + 65) + ':\autorun.inf';
        If FileExists(Chr(65 + i) + ':\autorun.inf') Then
        Begin
          inc(wx);
          FileSetAttr(Chr(65 + i) + ':\autorun.inf', 0);
          If safedel(Chr(65 + i) + ':\autorun.inf') Then
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'Anti-virus';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('found ' + Chr(65 + i) + ':\autorun.inf,delete.');
          End
          Else
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'error';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('delete ' + Chr(65 + i) + ':\autorun.inf,failed.');
          End;
        End;
        Form3.spSkinLabel3.Caption := 'number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'number of virus: ' + inttostr(wx);
        Application.ProcessMessages;
        inc(fc);
        Form3.spSkinLabel2.Caption := 'found: ' + char(i + 65) + ':\recycle.exe';
        If FileExists(Chr(65 + i) + ':\recycle.exe') Then
        Begin
          inc(wx);
          FileSetAttr(Chr(65 + i) + ':\recycle.exe', 0);
          If safedel(Chr(65 + i) + ':\recycle.exe') Then
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'Anti-virus';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('found ' + Chr(65 + i) + ':\recycle.exe,deleted.');
          End
          Else
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'error';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('delete ' + Chr(65 + i) + ':\recycle.exe,failed.');
          End;
        End;
        Form3.spSkinLabel3.Caption := 'number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'number of virus: ' + inttostr(wx);
        Application.ProcessMessages;
        inc(fc);
        Form3.spSkinLabel2.Caption := 'Checking: ' + char(i + 65) + ':\auto.exe';
        If FileExists(Chr(65 + i) + ':\auto.exe') Then
        Begin
          inc(wx);
          FileSetAttr(Chr(65 + i) + ':\auto.exe', 0);
          If safedel(Chr(65 + i) + ':\auto.exe') Then
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'Anti-virus';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('found ' + Chr(65 + i) + ':\auto.exe,deleted.');
          End
          Else
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'error';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('delete ' + Chr(65 + i) + ':\auto.exe,failed.');
          End;
        End;
        Form3.spSkinLabel3.Caption := 'number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'number of virus: ' + inttostr(wx);
        Application.ProcessMessages;
        inc(fc);
        Form3.spSkinLabel2.Caption := 'checking: ' + char(i + 65)
          + ':\explorer.exe';
        If FileExists(Chr(65 + i) + ':\explorer.exe') Then
        Begin
          inc(wx);
          FileSetAttr(Chr(65 + i) + ':\explorer.exe', 0);
          If safedel(Chr(65 + i) + ':\explorer.exe') Then
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := '������';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('found ' + Chr(65 + i) + ':\explorer.exe,deleted.');
          End
          Else
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'error';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('Delete ' + Chr(65 + i) + ':\explorer.exe,failed.');
          End;
        End;
        Form3.spSkinLabel3.Caption := 'Number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'Number of virus: ' + inttostr(wx);
        Application.ProcessMessages;
        inc(fc);
        Form3.spSkinLabel2.Caption := 'Checking: ' + char(i + 65) + ':\ms-dos.com';
        If FileExists(Chr(65 + i) + ':\ms-dos.com') Then
        Begin
          inc(wx);
          FileSetAttr(Chr(65 + i) + ':\ms-dos.com', 0);
          If safedel(Chr(65 + i) + ':\ms-dos.com') Then
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'Anti-virus';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('found ' + Chr(65 + i) + ':\ms-dos.com,delete.');
          End
          Else
          Begin
            temp := spSkinListView1.Items.Add;
            temp.Caption := 'error';
            temp.SubItems.Add(FormatDateTime('cc', Now()));
            temp.SubItems.Add('delete ' + Chr(65 + i) + ':\ms-dos.com,failed.');
          End;
        End;
        Form3.spSkinLabel3.Caption := 'Number of checked files: ' + inttostr(fc);
        Form3.spSkinLabel4.Caption := 'Number of virus: ' + inttostr(wx);
        Application.ProcessMessages;
        For i := 0 To d.Count - 1 Do
        Begin
          inc(fc);
          If FileExists(d[i] + '.exe') Then
          Begin
            Form3.spSkinLabel2.Caption := 'Checking file: ' + d[i] + '.exe';
            inc(wx);
            FileSetAttr(d[i] + '.exe', 0);
            If safedel(d[i] + '.exe') Then
            Begin
              temp := spSkinListView1.Items.Add;
              temp.Caption := 'Anti-virus';
              temp.SubItems.Add(FormatDateTime('cc', Now()));
              temp.SubItems.Add('found ' + d[i] + '.exe,deleted.');
            End
            Else
            Begin
              temp := spSkinListView1.Items.Add;
              temp.Caption := 'error';
              temp.SubItems.Add(FormatDateTime('cc', Now()));
              temp.SubItems.Add('delete ' + d[i] + '.exe failed.');
            End;
          End;
          Form3.spSkinLabel3.Caption := 'Number of checked files: ' + inttostr(fc);
          Form3.spSkinLabel4.Caption := 'Number of virus: ' + inttostr(wx);
          Application.ProcessMessages;
        End;
        Form3.spSkinLabel2.Caption := 'File: -';
        Form3.spSkinAnimateGauge1.StopAnimation;
        Form3.spSkinAnimateGauge1.ShowProgressText := true;
        Form3.Timer1.Enabled := true;
      // End Kill Virus
        temp := spSkinListView1.Items.Add;
        temp.Caption := 'Note';
        temp.SubItems.Add(FormatDateTime('cc', Now()));
        temp.SubItems.Add(char(c + 65) + ':\ Finished.');
      End;
  End;
End;


Procedure TForm1.Find(path: String; Var dlist: TStrings);
Var
  exepath: String;
  sr: TSearchRec;
  err: Integer;
Begin
  exepath := ExtractFilePath(Application.ExeName);
  err := FindFirst(path + '*.*', faAnyFile, sr);
  While err = 0 Do
  Begin
    If Not((sr.Name = '.') Or (sr.Name = '..')) Then
    Begin
      If (sr.Attr And faDirectory) = faDirectory Then
      Begin
        dlist.Add(path + sr.Name);
      End;
    End;
    err := FindNext(sr);
  End;
  FindClose(sr);
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
  Form1.Hide;
  CanClose := false;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Var
  f: TextFile;
  i: ShortInt;
  str: String;
Begin
  d := TStringList.Create;
  d.Clear;
  spSkinListView1.Items.Clear;
  spSkinScrollBar1.Both := true;
  If Not FileExists(ExtractFilePath(Application.ExeName)
      + 'Settings\Settings.sav') Then
  Begin
    Application.MessageBox('No file!', 'error', MB_OK + MB_ICONSTOP);
    Application.Terminate;
  End;
  AssignFile(f, ExtractFilePath(Application.ExeName) + 'Settings\Settings.sav');
  Reset(f);
  Readln(f, i);
  autorun := (i = 1);
  CloseFile(f);
  If autorun Then
    str := 'Automation'
  Else
    str := 'User selected';
  spTrayIcon1.ShowBalloonHint('Serum Anti_Virus V1.0',
    'Serum Anti-Virus start on' + #13#10 + 'Time:  ' + FormatDateTime('cc', Now())
      + #13#10 + 'Type:  ' + str, spbitInfo);
  If autorun Then
    spSkinButton1Click(Sender);
End;

Procedure TForm1.N4Click(Sender: TObject);
Begin
 If MessageBox(Handle, 'Are you sure to exit?', 'Ask', MB_YESNO + MB_ICONQUESTION)
    = IDYES Then
  Begin
    Application.Terminate;
  End;

End;

procedure TForm1.N6Click(Sender: TObject);
begin
  Form5.ShowModal;
end;

Procedure TForm1.N8Click(Sender: TObject);
Begin
  Form1.Show;
End;

Procedure TForm1.SerumAntiVirusV101Click(Sender: TObject);
Begin
  Form2.ShowModal;
End;

Procedure TForm1.spSkinButton1Click(Sender: TObject);
Var
  temp: TListItem;
Begin
  temp := spSkinListView1.Items.Add;
  temp.Caption := 'Action';
  If spSkinButton1.Caption = 'Start monitoring' Then
  Begin
    temp.SubItems.Add(FormatDateTime('cc', Now()));
    temp.SubItems.Add('Serum Anti-Virus start monitoring.');
    Application.ProcessMessages;
    spSkinButton1.Caption := 'stop monitoring';
    run := true;
  End
  Else
  Begin
    run := false;
    temp.SubItems.Add(FormatDateTime('cc', Now()));
    spSkinButton1.Caption := 'Start monitoring';
    temp.SubItems.Add('Serum Anti-Virus stop monitoring.');
  End;
End;

Procedure TForm1.spSkinListView1Insert(Sender: TObject; Item: TListItem);
Begin
  If spSkinListView1.Items.Count > 0 Then
    spSkinListView1.ItemIndex := spSkinListView1.Items.Count - 1;
End;

Procedure TForm1.Timer1Timer(Sender: TObject);
Begin
  spTrayIcon1.HideBalloonHint;
  Timer1.Enabled := false;
End;

End.
