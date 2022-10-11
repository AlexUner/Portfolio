object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'TForm1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 8
    Top = 27
    Width = 121
    Height = 73
    Caption = 'create'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 135
    Top = 27
    Width = 66
    Height = 73
    Caption = 'delete'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 106
    Width = 193
    Height = 89
    Caption = 'Button3'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 207
    Top = 27
    Width = 410
    Height = 264
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 11
    Top = 258
  end
end
