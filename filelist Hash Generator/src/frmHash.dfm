object Form1: TForm1
  Left = 380
  Top = 244
  Width = 628
  Height = 108
  Caption = 'GunProtect Hash'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 272
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Abrir'
    TabOrder = 0
    OnClick = btn1Click
  end
  object edt1: TEdit
    Left = 0
    Top = 8
    Width = 609
    Height = 21
    TabOrder = 1
  end
  object dlgOpen1: TOpenDialog
    Left = 96
    Top = 40
  end
  object tmr1: TTimer
    Interval = 100
    OnTimer = tmr1Timer
    Left = 24
    Top = 32
  end
end
