program POCR;

uses
  Vcl.Forms,
  UnitOCR in 'UnitOCR.pas' {OCRForm} ,
  tesseractocr.capi in 'tesseractocr.capi.pas',
  tesseractocr.leptonica in 'tesseractocr.leptonica.pas',
  tesseractocr in 'tesseractocr.pas',
  tesseractocr.pagelayout in 'tesseractocr.pagelayout.pas',
  tesseractocr.utils in 'tesseractocr.utils.pas',
  tesseractocr.consts in 'tesseractocr.consts.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Dusk');
  Application.CreateForm(TOCRForm, OCRForm);
  Application.Run;

end.
