Unit Unit3;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, DynamicSkinForm, SkinExCtrls, SkinCtrls, ExtCtrls;

Type
  TForm3 = Class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinLabel1: TspSkinLabel;
    spSkinLabel2: TspSkinLabel;
    spSkinLabel3: TspSkinLabel;
    spSkinAnimateGauge1: TspSkinAnimateGauge;
    spSkinLabel4: TspSkinLabel;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    Timer1: TTimer;
    Procedure FormCreate(Sender: TObject);
    Procedure spSkinButton2Click(Sender: TObject);
    Procedure spSkinButton1Click(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    Procedure typeform;
  End;

Var
  Form3: TForm3;

Implementation

Uses Unit1;
{$R *.dfm}

Procedure TForm3.FormCreate(Sender: TObject);
Begin
  typeform;
End;

Procedure TForm3.spSkinButton1Click(Sender: TObject);
Begin
  Timer1.Enabled := False;
  Form3.Hide;
End;

Procedure TForm3.spSkinButton2Click(Sender: TObject);
Begin
  Timer1.Enabled := False;
  Form3.Hide;
  Form1.Show;
End;

Procedure TForm3.Timer1Timer(Sender: TObject);
Begin
  Form3.Hide;
  Timer1.Enabled := False;
End;

Procedure TForm3.typeform;
Var
  abd: TAppBarData;
Begin
  abd.cbSize := sizeof(abd);
  SHAppBarMessage(ABM_GETTASKBARPOS, abd);
  // 定位到屏幕右下角
  Top := Screen.Height - Form3.Height - abd.rc.Bottom + abd.rc.Top;
  Left := Screen.Width - Form3.Width;
End;

End.
