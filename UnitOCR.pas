unit UnitOCR;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  System.UITypes, System.Types, System.IOUtils, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Samples.Spin,
  tesseractocr, Vcl.Menus, iexRichEdit;

type
  TOCRForm = class(TForm)
    btnOpenFile: TButton;
    OpenDialogImage: TOpenDialog;
    StatusBar: TStatusBar;
    panTop: TPanel;
    btnRecognize: TButton;
    btnCancel: TButton;
    cbPageSegMode: TComboBox;
    labAnalysisMode: TLabel;
    pbRecognizeProgress: TProgressBar;
    pgTabs: TPageControl;
    tabImage: TTabSheet;
    pbImage: TPaintBox;
    tabText: TTabSheet;
    ComboBox1: TComboBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    SaveDialog1: TSaveDialog;
    memText: TIERichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnRecognizeClick(Sender: TObject);
    procedure pbImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure pbImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbImagePaint(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure FormResize(Sender: TObject);
    procedure pbLayoutPaint(Sender: TObject);
    procedure pbLayoutMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    FSelectingROI: Boolean;
    FSelectionROI: TRect;
    FImageROI: TRect;
    FStretchDrawRect: TRect;
    FSourceImage: TBitmap;
    FSourceImageFileName: String;
    FSelectedLayoutItem: TObject;
    procedure OnRecognizeBegin(Sender: TObject);
    procedure OnRecognizeProgress(Sender: TObject; AProgress: Integer;
      var ACancel: Boolean);
    procedure OnRecognizeEnd(Sender: TObject; ACanceled: Boolean);
  public
    Masir: string;
    { Public declarations }
  end;

var
  OCRForm: TOCRForm;

implementation

uses
  tesseractocr.pagelayout,
  tesseractocr.utils,
  tesseractocr.capi;

{$R *.dfm}
{ TTesseractOCRImageForm }

procedure TOCRForm.FormCreate(Sender: TObject);
var
  progressBarStyle: Integer;
begin
  Masir := GetCurrentDir + '\data\';
  OpenDialogImage.InitialDir := GetCurrentDir+'\'+'Sample Images';
  FSelectingROI := False;
  progressBarStyle := GetWindowLong(pbRecognizeProgress.Handle, GWL_EXSTYLE);
  progressBarStyle := progressBarStyle and not WS_EX_STATICEDGE;
  SetWindowLong(pbRecognizeProgress.Handle, GWL_EXSTYLE, progressBarStyle);
  cbPageSegMode.ItemIndex := Ord(PSM_AUTO_OSD);

  Tesseract := TTesseractOCR4.Create;
  Tesseract.OnRecognizeBegin := OnRecognizeBegin;
  Tesseract.OnRecognizeProgress := OnRecognizeProgress;
  Tesseract.OnRecognizeEnd := OnRecognizeEnd;
  if not Tesseract.Initialize(Masir, '1', oemDefault) then
  begin
    MessageDlg('!فایل داده در مسیر فایل اجرایی پیدا نشد', mtError, [mbOk], 0);
    Application.ShowMainForm := False;
    Application.Terminate;
  end;
end;

procedure TOCRForm.FormDestroy(Sender: TObject);
begin
  Tesseract.Free;
  if Assigned(FSourceImage) then
    FSourceImage.Free;
end;

procedure TOCRForm.FormResize(Sender: TObject);
begin
  FSelectionROI.Width := 0;
  FSelectionROI.Height := 0;
  FImageROI.Width := 0;
  FImageROI.Height := 0;
end;

procedure TOCRForm.N1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    memText.Lines.SaveToFile(SaveDialog1.FileName);
end;

Procedure TOCRForm.pbImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FStretchDrawRect.Contains(Point(X, Y)) then
  begin
    FSelectionROI.Left := X;
    FSelectionROI.Top := Y;
    FSelectingROI := True;
  end;
end;

procedure TOCRForm.pbImageMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FSelectingROI and FStretchDrawRect.Contains(Point(X, Y)) then
  begin
    FSelectionROI.Right := X;
    FSelectionROI.Bottom := Y;
    pbImage.Invalidate;
  end;
end;

procedure TOCRForm.pbImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FStretchDrawRect.Contains(Point(X, Y)) then
  begin
    FSelectingROI := False;
    FSelectionROI.Right := X;
    FSelectionROI.Bottom := Y;
    FSelectionROI.NormalizeRect;
    FImageROI.Create(FSelectionROI, False);
    FImageROI.Offset(-FStretchDrawRect.Left, -FStretchDrawRect.Top);
    FImageROI.Left :=
      Round(FImageROI.Left * (FSourceImage.Width / FStretchDrawRect.Width));
    FImageROI.Top :=
      Round(FImageROI.Top * (FSourceImage.Height / FStretchDrawRect.Height));
    FImageROI.Right :=
      Round(FImageROI.Right * (FSourceImage.Width / FStretchDrawRect.Width));
    FImageROI.Bottom :=
      Round(FImageROI.Bottom * (FSourceImage.Height / FStretchDrawRect.Height));
    pbImage.Invalidate;
  end;
end;

procedure TOCRForm.pbImagePaint(Sender: TObject);

  function ProportionalResize(AX, AY, AOrgWidth, AOrgHeight, AMaxWidth,
    AMaxHeight: Integer): TRect;
  var
    w, h: Single;
    X, Y: Single;
  begin
    X := AX;
    Y := AY;
    if (AOrgWidth > AOrgHeight) then
    begin
      w := AMaxWidth;
      h := (AMaxWidth * AOrgHeight) / AOrgWidth;
      if (h > AMaxHeight) then
      begin
        w := (AMaxHeight * AOrgWidth) / AOrgHeight;
        h := AMaxHeight;
      end;
    end
    else
    begin
      w := (AMaxHeight * AOrgWidth) / AOrgHeight;
      h := AMaxHeight;
      if (w > AMaxWidth) then
      begin
        w := AMaxWidth;
        h := (AMaxWidth * AOrgHeight) / AOrgWidth;
      end;
    end;
    Y := Y + (Abs(AMaxHeight - h) / 2);
    X := X + (Abs(AMaxWidth - w) / 2);
    Result := Rect(Trunc(X), Trunc(Y), Trunc(w + X), Trunc(h + Y));
  end;

begin
  if not Assigned(FSourceImage) then
    Exit;
  FStretchDrawRect := ProportionalResize(0, 0, FSourceImage.Width,
    FSourceImage.Height, pbImage.BoundsRect.Width, pbImage.BoundsRect.Height);
  pbImage.Canvas.StretchDraw(FStretchDrawRect, FSourceImage);
  pbImage.Canvas.Brush.Style := bsClear;
  pbImage.Canvas.Pen.Style := psDash;
  pbImage.Canvas.Pen.Color := clRed;
  pbImage.Canvas.Rectangle(FSelectionROI);
end;

procedure TOCRForm.pbLayoutMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  para: TTesseractParagraph;
  textLine: TTesseractTextLine;
  word: TTesseractWord;
begin
  if not Assigned(FSourceImage) then
    Exit;
  if not Tesseract.pagelayout.DataReady then
    Exit;

  for word in Tesseract.pagelayout.Words do
  begin
    if word.BoundingRect.Contains(Point(X, Y)) then
    begin
      FSelectedLayoutItem := word;
      Exit;
    end;
  end;
  for textLine in Tesseract.pagelayout.TextLines do
  begin
    if textLine.BoundingRect.Contains(Point(X, Y)) then
    begin
      FSelectedLayoutItem := textLine;
      Exit;
    end;
  end;
  for para in Tesseract.pagelayout.Paragraphs do
  begin
    if para.BoundingRect.Contains(Point(X, Y)) then
    begin
      FSelectedLayoutItem := para;
      Exit;
    end;
  end;
end;

procedure TOCRForm.pbLayoutPaint(Sender: TObject);

  procedure DrawRectAndTextAbove(ACanvas: TCanvas; AText: String;
    AColor: TColor; ARect: TRect);
  var
    textSize: TSize;
  begin
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Color := AColor;
    ACanvas.Rectangle(ARect);
    ACanvas.Brush.Color := clGray;
    ACanvas.Pen.Color := clGray;
    ACanvas.Brush.Style := bsSolid;
    textSize := ACanvas.TextExtent(AText);
    ACanvas.Rectangle(Rect(ARect.Left, ARect.Top - textSize.Height - 4,
      ARect.Left + textSize.Width + 4, ARect.Top));
    ACanvas.TextOut(ARect.Left + 2, ARect.Top - textSize.Height - 2, AText);
  end;

var
  block: TTesseractBlock;
  para: TTesseractParagraph;
  textLine: TTesseractTextLine;
  word: TTesseractWord;
  symbol: TTesseractSymbol;
  text: String;
begin
  if not Assigned(FSourceImage) then
    Exit;
  if not Tesseract.pagelayout.DataReady then
    Exit;
  if Assigned(FSelectedLayoutItem) then
  begin
  end;
end;

Procedure TOCRForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if (Panel.Index = 0) then
  begin
    pbRecognizeProgress.Top := Rect.Top;
    pbRecognizeProgress.Left := Rect.Left;
    pbRecognizeProgress.Width := Rect.Right - Rect.Left;
    pbRecognizeProgress.Height := Rect.Bottom - Rect.Top;
  end;
end;

procedure TOCRForm.btnOpenFileClick(Sender: TObject);
begin
  if Tesseract.Busy then
    Exit;
  if OpenDialogImage.Execute then
  begin
    if Assigned(FSourceImage) then
      FreeAndNil(FSourceImage);
    if Tesseract.SetImage(OpenDialogImage.FileName) then
    begin
      FSourceImageFileName := OpenDialogImage.FileName;
      StatusBar.Panels[0].text := FSourceImageFileName;
      FSourceImage := Tesseract.GetSourceImageBMP;
      FSelectionROI := Rect(0, 0, 0, 0);
      btnRecognize.Enabled := True;
      pgTabs.ActivePage := tabImage;
      pbImage.Invalidate;
    end;
  end;
end;

procedure TOCRForm.btnRecognizeClick(Sender: TObject);
begin

  if ComboBox1.ItemIndex = -1 then
  begin
    ShowMessage('ابتدا زبان متن موجود در تصویر را انتخاب کنید');
    ComboBox1.SetFocus;
    Exit;
  end;

  if not Tesseract.Initialize(Masir, IntToStr(ComboBox1.ItemIndex + 1),
    oemDefault) then
  begin
    MessageDlg('!فایل داده در مسیر فایل اجرایی پیدا نشد', mtError, [mbOk], 0);
    Application.ShowMainForm := False;
    Application.Terminate;
  end;

  if not Assigned(FSourceImage) then
    Exit;

  if (FImageROI.Width > 0) and (FImageROI.Height > 0) then
  begin
    Tesseract.SetRectangle(FImageROI);
  end
  else
    Tesseract.SetRectangle(Rect(0, 0, FSourceImage.Width, FSourceImage.Height));

  Tesseract.PageSegMode := TessPageSegMode(cbPageSegMode.ItemIndex);
  Tesseract.Recognize;
end;

procedure TOCRForm.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 1 then
    memText.BiDiMode := bdLeftToRight
  else
    memText.BiDiMode := bdRightToLeft;
end;

Procedure TOCRForm.btnCancelClick(Sender: TObject);
begin
  Tesseract.CancelRecognize;
end;

procedure TOCRForm.OnRecognizeBegin(Sender: TObject);
begin
  memText.Clear;
  FSelectedLayoutItem := nil;
  btnCancel.Enabled := True;
  btnRecognize.Enabled := False;
  pbRecognizeProgress.Position := 1;
  pgTabs.ActivePage := tabText;
  btnOpenFile.Enabled := False;
end;

procedure TOCRForm.OnRecognizeProgress(Sender: TObject; AProgress: Integer;
  var ACancel: Boolean);
begin
  pbRecognizeProgress.Position := AProgress;
end;

procedure TOCRForm.OnRecognizeEnd(Sender: TObject; ACanceled: Boolean);
var
  symbol: TTesseractSymbol;
  word: TTesseractWord;
  textLine: TTesseractTextLine;
  para: TTesseractParagraph;
  block: TTesseractBlock;
  blockTree, paraTree, textLineTree, wordTree: TTreeNode;
begin
  btnCancel.Enabled := False;
  btnRecognize.Enabled := True;
  btnOpenFile.Enabled := True;
  pbRecognizeProgress.Position := 0;
  if not ACanceled then
  begin
    memText.text := Tesseract.UTF8Text;
    for block in Tesseract.pagelayout.Blocks do
    begin
    end;
    if pgTabs.ActivePage = tabImage then
      pgTabs.ActivePage := tabText;
  end
  else
    pbRecognizeProgress.Position := 0;
end;

end.
