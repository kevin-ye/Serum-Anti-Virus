Unit Unit5;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkinCtrls, DynamicSkinForm;

Type
  TForm5 = Class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinButton1: TspSkinButton;
    spSkinButton2: TspSkinButton;
    spSkinCheckRadioBox1: TspSkinCheckRadioBox;
    spSkinCheckRadioBox2: TspSkinCheckRadioBox;
    procedure spSkinButton2Click(Sender: TObject);
    procedure spSkinButton1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  Form5: TForm5;

Implementation

Uses Unit1;
{$R *.dfm}

procedure TForm5.spSkinButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm5.spSkinButton2Click(Sender: TObject);
begin
  Close;
end;

End.
