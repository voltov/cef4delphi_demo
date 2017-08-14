object DialogMain: TDialogMain
  Left = 0
  Top = 0
  Caption = 'Cef4Delphi Demo'
  ClientHeight = 211
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BtnStart: TButton
    Left = 200
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = OnBtnStartClick
  end
  object BtnStop: TButton
    Left = 200
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = OnBtnStopClick
  end
end
