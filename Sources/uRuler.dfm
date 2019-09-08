inherited frmRuler: TfrmRuler
  Tag = -1
  Left = 557
  Top = 278
  BorderIcons = []
  ClientHeight = 210
  ClientWidth = 276
  Color = clSilver
  TransparentColorValue = clSilver
  Font.Charset = DEFAULT_CHARSET
  FormStyle = fsStayOnTop
  KeyPreview = True
  ScreenSnap = False
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  ExplicitWidth = 276
  ExplicitHeight = 210
  DesignSize = (
    276
    210)
  PixelsPerInch = 96
  TextHeight = 13
  object ShapeMain: TShape [0]
    Tag = -1
    Left = 0
    Top = 0
    Width = 276
    Height = 210
    Align = alClient
    Brush.Style = bsClear
    ParentShowHint = False
    Pen.Style = psDot
    ShowHint = False
  end
  object ImageCenter: TImage [1]
    Left = 126
    Top = 97
    Width = 13
    Height = 13
    Cursor = crHandPoint
    Anchors = []
    Center = True
    ParentShowHint = False
    ShowHint = False
    Transparent = True
  end
  object ShapeLeftTop: TShape [2]
    Left = 0
    Top = 0
    Width = 9
    Height = 9
  end
  object ShapeRightTop: TShape [3]
    Left = 263
    Top = 0
    Width = 9
    Height = 9
    Anchors = [akTop, akRight]
  end
  object ShapeLeftCenter: TShape [4]
    Left = 0
    Top = 88
    Width = 9
    Height = 9
    Anchors = [akLeft]
  end
  object ShapeRightBottom: TShape [5]
    Left = 260
    Top = 196
    Width = 9
    Height = 9
    Anchors = [akRight, akBottom]
  end
  object ShapeTopCenter: TShape [6]
    Left = 135
    Top = 0
    Width = 9
    Height = 9
    Anchors = [akTop]
  end
  object ShapeLeftBottom: TShape [7]
    Left = 0
    Top = 197
    Width = 9
    Height = 9
    Anchors = [akLeft, akBottom]
  end
  object ShapeBottomCenter: TShape [8]
    Left = 135
    Top = 197
    Width = 9
    Height = 9
    Anchors = [akBottom]
  end
  object ShapeRightCenter: TShape [9]
    Left = 260
    Top = 85
    Width = 9
    Height = 9
    Anchors = [akRight]
  end
  object ImageBlack: TImage [10]
    Left = 189
    Top = 132
    Width = 13
    Height = 13
    Anchors = []
    AutoSize = True
    Picture.Data = {
      07544269746D6170DE000000424DDE0000000000000076000000280000000D00
      00000D000000010004000000000068000000C40E0000C40E0000100000000000
      0000000000000000800000800000008080008000000080008000808000008080
      8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00DDDDDD0DDDDDD000DDDDDD0DDDDDD000DDDDDD0DDDDDD000DDDDD000DDDD
      D000DDDD0FFF0DDDD000DDD0FFFFF0DDD0000000FF0FF0000000DDD0FFFFF0DD
      D000DDDD0FFF0DDDD000DDDDD000DDDDD000DDDDDD0DDDDDD000DDDDDD0DDDDD
      D000DDDDDD0DDDDDD000}
    Transparent = True
    Visible = False
  end
  object ImageWhite: TImage [11]
    Left = 166
    Top = 132
    Width = 13
    Height = 13
    Anchors = []
    AutoSize = True
    Picture.Data = {
      07544269746D6170DE000000424DDE0000000000000076000000280000000D00
      00000D000000010004000000000068000000C40E0000C40E0000100000000000
      0000000000000000800000800000008080008000000080008000808000008080
      8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00DDDDDDFDDDDDD000DDDDDDFDDDDDD000DDDDDDFDDDDDD000DDDDDFFFDDDD
      D000DDDDF000FDDDD000DDDF00000FDDD000FFFF00F00FFFF000DDDF00000FDD
      D000DDDDF000FDDDD000DDDDDFFFDDDDD000DDDDDDFDDDDDD000DDDDDDFDDDDD
      D000DDDDDDFDDDDDD000}
    Transparent = True
    Visible = False
  end
  inherited ICSLanguages1: TICSLanguages
    Languages = <
      item
        LocaleName = 'English'
      end
      item
        Language = lGerman
        LocaleName = 'German'
      end
      item
        Language = lRussian
        LocaleName = 'Russian'
      end>
  end
end
