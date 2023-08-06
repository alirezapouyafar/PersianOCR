object OCRForm: TOCRForm
  Left = 0
  Top = 0
  BiDiMode = bdRightToLeft
  Caption = 
    '(Persian/English OCR Project - Programmer: Alireza Pouyafar (091' +
    '44075815'
  ClientHeight = 823
  ClientWidth = 821
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 700
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 802
    Width = 821
    Height = 21
    BiDiMode = bdLeftToRight
    Panels = <
      item
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        Width = 500
      end>
    ParentBiDiMode = False
    OnDrawPanel = StatusBarDrawPanel
  end
  object panTop: TPanel
    Left = 0
    Top = 0
    Width = 821
    Height = 71
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      821
      71)
    object labAnalysisMode: TLabel
      Left = 539
      Top = 40
      Width = 69
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1581#1575#1604#1578' '#1578#1588#1582#1740#1589':'
    end
    object Label1: TLabel
      Left = 701
      Top = 40
      Width = 113
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1586#1576#1575#1606' '#1605#1578#1606' '#1605#1608#1580#1608#1583' '#1583#1585' '#1578#1589#1608#1740#1585':'
    end
    object btnRecognize: TButton
      Left = 624
      Top = 8
      Width = 92
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = #1588#1585#1608#1593' '#1578#1588#1582#1740#1589
      Enabled = False
      TabOrder = 1
      OnClick = btnRecognizeClick
    end
    object btnCancel: TButton
      Left = 539
      Top = 8
      Width = 79
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = #1604#1594#1608
      Enabled = False
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnOpenFile: TButton
      Left = 722
      Top = 9
      Width = 92
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = #1575#1606#1578#1582#1575#1576' '#1578#1589#1608#1740#1585
      TabOrder = 0
      OnClick = btnOpenFileClick
    end
    object cbPageSegMode: TComboBox
      Left = 8
      Top = 38
      Width = 526
      Height = 21
      Cursor = crHandPoint
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 3
      Items.Strings = (
        #1601#1602#1591' '#1580#1607#1578' '#1711#1740#1585#1740' '#1608' '#1578#1588#1582#1740#1589' '#1575#1587#1705#1585#1740#1662#1578
        #1578#1602#1587#1740#1605' '#1576#1606#1583#1740' '#1582#1608#1583#1705#1575#1585' '#1589#1601#1581#1607' '#1576#1575' '#1580#1607#1578' '#1711#1740#1585#1740' '#1608' '#1578#1588#1582#1740#1589' '#1575#1587#1705#1585#1740#1662#1578
        #1578#1602#1587#1740#1605#8204#1576#1606#1583#1740' '#1582#1608#1583#1705#1575#1585' '#1589#1601#1581#1607#1548' '#1576#1583#1608#1606' OSD '#1740#1575' OCR'
        #1578#1602#1587#1740#1605' '#1576#1606#1583#1740' '#1705#1575#1605#1604#1575#1611' '#1582#1608#1583#1705#1575#1585' '#1589#1601#1581#1607#1548' '#1576#1583#1608#1606' OSD'
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1740#1705' '#1587#1578#1608#1606' '#1605#1578#1606#1740' '#1576#1575' '#1575#1606#1583#1575#1586#1607' '#1607#1575#1740' '#1605#1578#1594#1740#1585' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585#1740#1705' '#1576#1604#1608#1705' '#1740#1705#1606#1608#1575#1582#1578' '#1575#1586' '#1605#1578#1606' '#1578#1585#1575#1586' '#1593#1605#1608#1583#1740' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1740#1705' '#1576#1604#1608#1705' '#1740#1705#1606#1608#1575#1582#1578' '#1605#1578#1606' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1576#1607' '#1593#1606#1608#1575#1606' '#1582#1591#1608#1591' '#1605#1578#1606#1740' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1576#1607' '#1593#1606#1608#1575#1606' '#1740#1705' '#1705#1604#1605#1607' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1576#1607' '#1593#1606#1608#1575#1606' '#1740#1705' '#1705#1604#1605#1607' '#1583#1585' '#1740#1705' '#1583#1575#1740#1585#1607' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1578#1589#1608#1740#1585' '#1576#1607' '#1593#1606#1608#1575#1606' '#1740#1705' '#1605#1608#1580#1608#1583#1740#1578' '#1608#1575#1581#1583' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1578#1575' '#1580#1575#1740#1740' '#1705#1607' '#1605#1605#1705#1606' '#1575#1587#1578' '#1605#1578#1606' '#1576#1583#1608#1606' '#1578#1585#1578#1740#1576' '#1582#1575#1589#1740' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1605#1578#1606' '#1662#1585#1575#1705#1606#1583#1607' '#1576#1575' '#1580#1607#1578' '#1608' '#1575#1587#1705#1585#1740#1662#1578' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583
        #1578#1589#1608#1740#1585' '#1576#1607#8204' '#1593#1606#1608#1575#1606' '#1740#1705' '#1582#1591' '#1605#1578#1606' '#1608#1575#1581#1583' '#1583#1585' '#1606#1592#1585' '#1711#1585#1601#1578#1607' '#1588#1608#1583)
    end
    object pbRecognizeProgress: TProgressBar
      Left = 8
      Top = 8
      Width = 525
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Smooth = True
      TabOrder = 4
      StyleElements = [seFont]
    end
    object ComboBox1: TComboBox
      Left = 624
      Top = 38
      Width = 75
      Height = 22
      Style = csOwnerDrawFixed
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 5
      OnChange = ComboBox1Change
      Items.Strings = (
        #1601#1575#1585#1587#1740
        #1575#1606#1711#1604#1740#1587#1740)
    end
  end
  object pgTabs: TPageControl
    Left = 0
    Top = 71
    Width = 821
    Height = 731
    ActivePage = tabText
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 2
    object tabImage: TTabSheet
      Caption = #1578#1589#1608#1740#1585
      object pbImage: TPaintBox
        Left = 0
        Top = 0
        Width = 813
        Height = 700
        Cursor = crCross
        Align = alClient
        OnMouseDown = pbImageMouseDown
        OnMouseMove = pbImageMouseMove
        OnMouseUp = pbImageMouseUp
        OnPaint = pbImagePaint
        ExplicitTop = 80
        ExplicitHeight = 620
      end
    end
    object tabText: TTabSheet
      Caption = #1605#1578#1606
      ImageIndex = 1
      object memText: TIERichEdit
        Left = 0
        Top = 0
        Width = 813
        Height = 700
        RTFText = 
          '{\rtf1\fbidis\ansi\ansicpg1256\deff0\deflang1065{\fonttbl{\f0\fn' +
          'il\fcharset178 Tahoma;}}'#13#10'\viewkind4\uc1\pard\rtlpar\qr\f0\rtlch' +
          '\fs16\par'#13#10'}'#13#10#0
        Align = alClient
        Font.Charset = ARABIC_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu1
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitTop = 66
        ExplicitWidth = 821
        ExplicitHeight = 731
      end
    end
  end
  object OpenDialogImage: TOpenDialog
    Filter = 
      'Image files (jpg, bmp, png, gif, tiff, emf, wmf, webp)|*.jpg;*jp' +
      'eg;*.bmp;*.png;*.gif;*.tif;*.tiff;*.emf;*.wmf;*.webp'
    Left = 418
    Top = 256
  end
  object PopupMenu1: TPopupMenu
    Left = 408
    Top = 416
    object N1: TMenuItem
      Caption = #1584#1582#1740#1585#1607' '#1605#1578#1606' '#1583#1585' '#1601#1575#1740#1604
      OnClick = N1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text Files|*.txt'
    Left = 536
    Top = 320
  end
end
