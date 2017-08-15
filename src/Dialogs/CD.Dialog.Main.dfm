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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BtnStart: TButton
    Left = 192
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = OnBtnStartClick
  end
end
