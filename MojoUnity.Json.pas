(*
  This is original license
  ------------------------------------------------------------------------------------------------------------------------
  * Copyright (c) 2017-2018 scott.cgi All Rights Reserved.
  *
  * This code is licensed under the MIT License.
  *
  * Since  : 2017-9-6
  * Author : scott.cgi
  * Version: 1.1.8
  * Update : 2018-2-5
  ------------------------------------------------------------------------------------------------------------------------
  * Pascal version:
  * Author : Zhao Yipeng
  * Update : 2018-4-11
  * Version: 1.0
  ------------------------------------------------------------------------------------------------------------------------
*)

unit MojoUnity.Json;

interface

uses
  Classes, SysUtils, Generics.Collections;

type
  Float = Double;

  TJsonType = (
    &Object,
    &Array,
    &String,
    Number,
    Bool,
    Null
    );

  { TJsonValue }

  TJsonValue = class
  private
    FObjectValue: TObject;
    FNumberValue: Float;
    FType: TJsonType;
  public
    constructor Create(&type: TJsonType; value: TObject); overload;
    constructor Create(&type: TJsonType; value: Float); overload;
    destructor Destroy; override;
    /// <summary>
    /// Use JsonValue as JsonObject.
    /// </summary>
    function AsObject: TDictionary<string, TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonObject and get JsonValue item by key.
    /// return null if not found key.
    /// </summary>
    function AsObjectGet(const key: string): TJsonValue;

    /// <summary>
    /// Use JsonValue as JsonObject and get JsonObject item by key.
    /// return null if not found key.
    /// </summary>
    function AsObjectGetObject(const key: string)
      : TDictionary<string, TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonObject and get JsonArray item by key.
    /// return null if not found key.
    /// </summary>
    function AsObjectGetArray(const key: string): TList<TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonObject and get string item by key.
    /// return null if not found key.
    /// </summary>
    function AsObjectGetString(key: string; defaultValue: string = ''): string;

    /// <summary>
    /// Use JsonValue as JsonObject and get float item by key.
    /// return defaultValue if not found key.
    /// </summary>
    function AsObjectGetFloat(const key: string; defaultValue: Float)
      : Float; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and get float item by key.
    /// </summary>
    function AsObjectGetFloat(const key: string): Float; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and get int item by key.
    /// return defaultValue if not found key.
    /// </summary>
    function AsObjectGetInt(const key: string; defaultValue: Integer)
      : Integer; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and get int item by key.
    /// </summary>
    function AsObjectGetInt(const key: string): Integer; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and get bool item by key.
    /// return defaultValue if not found key.
    /// </summary>
    function AsObjectGetBool(const key: string; defaultValue: Boolean)
      : Boolean; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and get int item by key.
    /// </summary>
    function AsObjectGetBool(const key: string): Boolean; overload;

    /// <summary>
    /// Use JsonValue as JsonObject and check null item by key.
    /// </summary>
    function AsObjectGetIsNull(const key: string): Boolean;

    /// <summary>
    /// Use JsonValue as JsonArray.
    /// </summary>
    function AsArray: TList<TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonArray and get JsonValue item by index.
    /// </summary>
    function AsArrayGet(index: Integer): TJsonValue;

    /// <summary>
    /// Use JsonValue as JsonArray and get JsonObject item by index.
    /// </summary>
    function AsArrayGetObject(index: Integer): TDictionary<string, TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonArray and get JsonArray item by index.
    /// </summary>
    function AsArrayGetArray(index: Integer): TList<TJsonValue>;

    /// <summary>
    /// Use JsonValue as JsonArray and get string item by index.
    /// </summary>
    function AsArrayGetString(index: Integer): string;

    /// <summary>
    /// Use JsonValue as JsonArray and get float item by index.
    /// </summary>
    function AsArrayGetFloat(index: Integer): Float;

    /// <summary>
    /// Use JsonValue as JsonArray and get int item by index.
    /// </summary>
    function AsArrayGetInt(index: Integer): Integer;

    /// <summary>
    /// Use JsonValue as JsonArray and get bool item by index.
    /// </summary>
    function AsArrayGetBool(index: Integer): Boolean;

    /// <summary>
    /// Use JsonValue as JsonArray and check null item by index.
    /// </summary>
    function AsArrayGetIsNull(index: Integer): Boolean;

    /// <summary>
    /// Get JsonValue as string.
    /// </summary>
    function AsString: string;

    /// <summary>
    /// Get JsonValue as float.
    /// </summary>
    function AsFloat: Float;

    /// <summary>
    /// Get JsonValue as int.
    /// </summary>
    function AsInt: Integer;

    /// <summary>
    /// Get JsonValue as bool.
    /// </summary>
    function AsBool: Boolean;

    /// <summary>
    /// Whether JsonValue is null £¿
    /// </summary>
    function IsNull: Boolean;

    property &type: TJsonType read FType;
  end;

  TJson = class
  private const
    JsonObjectInitCapacity: Integer = 8;
    JsonArrayInitCapacity: Integer = 8;
  private type
    TData = class
    public
      Json: string;
      index: Integer;
      sb: TStringBuilder;
      constructor Create(Json: string);
      destructor Destroy; override;
    end;
  private

    /// <summary>
    /// Parse the JsonValue.
    /// </summary>
    class function ParseValue(data: TData): TJsonValue;

    /// <summary>
    /// Parse JsonObject.
    /// </summary>
    class function ParseObject(data: TData): TJsonValue;

    /// <summary>
    /// Parse JsonArray.
    /// </summary>
    class function ParseArray(data: TData): TJsonValue;

    /// <summary>
    /// Parses the JsonString.
    /// </summary>
    class function ParseString(data: TData): TJsonValue;

    /// <summary>
    /// Parses the JsonNumber.
    /// </summary>
    class function ParseNumber(data: TData): TJsonValue;

    /// <summary>
    /// Skip the white space.
    /// </summary>
    class procedure SkipWhiteSpace(data: TData);

    /// <summary>
    /// Get the unicode code point.
    /// </summary>
    class function GetUnicodeCodePoint(c1, c2, c3, c4: Char): Char;

    /// <summary>
    /// Single unicode char convert to int.
    /// </summary>
    class function UnicodeCharToInt(c: Char): Integer;
  public
    /// <summary>
    /// Parse json string.
    /// </summary>
    class function Parse(const json: string): TJsonValue;
  end;

implementation

type
  TDebugTool = class
  public
    class procedure Assert(condition: Boolean; const msg: string;
      const args: array of const);
  end;

  TStringValue = class
    value: string;
    constructor Create(const value: string);
  end;

  { TDebugTool }

class procedure TDebugTool.Assert(condition: Boolean; const msg: string;
  const args: array of const);
begin
  if (condition = false) then
  begin
    raise Exception.CreateFmt(msg, args);
  end;
end;

{ TStringValue }

constructor TStringValue.Create(const value: string);
begin
  Self.value := value;
end;

{ TJsonValue }

constructor TJsonValue.Create(&type: TJsonType; value: TObject);
begin
  Self.FType := &type;
  Self.FObjectValue := value;
end;

function TJsonValue.AsArray: TList<TJsonValue>;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Array,
    'JsonValue type is not Array !', []);
  Result := Self.FObjectValue as TList<TJsonValue>;
end;

function TJsonValue.AsArrayGet(index: Integer): TJsonValue;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Array,
    'JsonValue type is not Array !', []);
  Result := (Self.FObjectValue as TList<TJsonValue>)[index];
end;

function TJsonValue.AsArrayGetArray(index: Integer): TList<TJsonValue>;
begin
  Result := Self.AsArrayGet(index).AsArray;
end;

function TJsonValue.AsArrayGetBool(index: Integer): Boolean;
begin
  Result := Self.AsArrayGet(index).AsBool;
end;

function TJsonValue.AsArrayGetFloat(index: Integer): Float;
begin
  Result := Self.AsArrayGet(index).AsFloat;
end;

function TJsonValue.AsArrayGetInt(index: Integer): Integer;
begin
  Result := Self.AsArrayGet(index).AsInt;
end;

function TJsonValue.AsArrayGetIsNull(index: Integer): Boolean;
begin
  Result := Self.AsArrayGet(index).IsNull;
end;

function TJsonValue.AsArrayGetObject(
  index: Integer): TDictionary<string, TJsonValue>;
begin
  Result := Self.AsArrayGet(index).AsObject;
end;

function TJsonValue.AsArrayGetString(index: Integer): string;
begin
  Result := Self.AsArrayGet(index).AsString;
end;

function TJsonValue.AsBool: Boolean;
var
  msg: string;
begin
  msg := 'JsonValue type is not Bool !';
  TDebugTool.Assert(Self.FType = TJsonType.Bool, msg, []);
  Result := Self.FNumberValue > 0.0;
end;

function TJsonValue.AsFloat: Float;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Number,
    'JsonValue type is not Number !', []);
  Result := Self.FNumberValue;
end;

function TJsonValue.AsInt: Integer;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Number,
    'JsonValue type is not Number !', []);
  Result := Round(Self.FNumberValue);
end;

function TJsonValue.AsObject: TDictionary<string, TJsonValue>;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Object,
    'JsonValue type is not Object !', []);
  Result := Self.FObjectValue as TDictionary<string, TJsonValue>;
end;

function TJsonValue.AsObjectGet(const key: string): TJsonValue;
var
  dict: TDictionary<string, TJsonValue>;
  jsonValue: TJsonValue;
begin
  TDebugTool.Assert(Self.FType = TJsonType.Object,
    'JsonValue type is not Object !', []);
  dict := Self.FObjectValue as TDictionary<string, TJsonValue>;

  if (dict.TryGetValue(key, jsonValue)) then
  begin
    Result := jsonValue;
  end
  else
  begin
    Result := nil;
  end;
end;

function TJsonValue.AsObjectGetArray(const key: string): TList<TJsonValue>;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsArray;
  end
  else
  begin
    Result := nil;
  end;
end;

function TJsonValue.AsObjectGetBool(const key: string;
  defaultValue: Boolean): Boolean;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsBool;
  end
  else
  begin
    Result := defaultValue;
  end;
end;

function TJsonValue.AsObjectGetBool(const key: string): Boolean;
begin
  Result := Self.AsObjectGet(key).AsBool;
end;

function TJsonValue.AsObjectGetFloat(const key: string): Float;
begin
  Result := Self.AsObjectGet(key).AsFloat;
end;

function TJsonValue.AsObjectGetInt(const key: string;
  defaultValue: Integer): Integer;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsInt;
  end
  else
  begin
    Result := defaultValue;
  end;
end;

function TJsonValue.AsObjectGetInt(const key: string): Integer;
begin
  Result := Self.AsObjectGet(key).AsInt;
end;

function TJsonValue.AsObjectGetIsNull(const key: string): Boolean;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.IsNull;
  end
  else
  begin
    Result := false;
  end;
end;

function TJsonValue.AsObjectGetFloat(const key: string;
  defaultValue: Float): Float;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsFloat;
  end
  else
  begin
    Result := defaultValue;
  end;
end;

function TJsonValue.AsObjectGetObject(
  const key: string): TDictionary<string, TJsonValue>;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsObject;
  end
  else
  begin
    Result := nil;
  end;
end;

function TJsonValue.AsObjectGetString(key: string;
  defaultValue: string): string;
var
  jsonValue: TJsonValue;
begin
  jsonValue := Self.AsObjectGet(key);

  if (jsonValue <> nil) then
  begin
    Result := jsonValue.AsString;
  end
  else
  begin
    Result := defaultValue;
  end;
end;

function TJsonValue.AsString: string;
begin
  TDebugTool.Assert(Self.FType = TJsonType.String,
    'JsonValue type is not String !', []);
  Result := (Self.FObjectValue as TStringValue).value;
end;

constructor TJsonValue.Create(&type: TJsonType; value: Float);
begin
  Self.FType := &type;
  Self.FObjectValue := nil;
  Self.FNumberValue := value;
end;

destructor TJsonValue.Destroy;
begin
  Self.FObjectValue.Free;
  inherited;
end;

function TJsonValue.IsNull: Boolean;
begin
  Result := Self.FType = TJsonType.Null;
end;

{ TJson.TData }

constructor TJson.TData.Create(Json: string);
begin
  Self.Json := Json;
  Self.index := 0;
  Self.sb := TStringBuilder.Create;
end;

destructor TJson.TData.Destroy;
begin
  sb.Free;
  inherited;
end;

{ TJson }

class function TJson.GetUnicodeCodePoint(c1, c2, c3, c4: Char): Char;
begin
  Result := Char
    (
    UnicodeCharToInt(c1) * $1000 +
    UnicodeCharToInt(c2) * $100 +
    UnicodeCharToInt(c3) * $10 +
    UnicodeCharToInt(c4)
    );
end;

class function TJson.Parse(const json: string): TJsonValue;
var
  data: TData;
begin
  data := TData.Create(json);
  try
    Result := ParseValue(data);
  finally
    data.Free;
  end;
end;

class function TJson.ParseArray(data: TData): TJsonValue;
var
  jsonArray: TList<TJsonValue>;
begin
  jsonArray := TObjectList<TJsonValue>.Create;

  // skip '['
  Inc(data.index);

  repeat
    SkipWhiteSpace(data);

    if (data.Json.Chars[data.index] = ']') then
    begin
      break;
    end;

    // add JsonArray item
    jsonArray.Add(ParseValue(data));

    SkipWhiteSpace(data);

    if (data.Json.Chars[data.index] = ',') then
    begin
      Inc(data.index);
    end
    else
    begin
      TDebugTool.Assert
        (
        data.json.Chars[data.index] = ']',
        'Json ParseArray error, char ''%s'' should be '']'' ',
        [data.json.Chars[data.index]]
        );
      break;
    end;
  until (false);

  // skip ']'
  Inc(data.index);

  Result := TJsonValue.Create(TJsonType.Array, jsonArray);
end;

class function TJson.ParseNumber(data: TData): TJsonValue;
var
  start: Integer;
  strNum: string;
  num: Float;
begin
  start := data.index;

  while (true) do
  begin
    Inc(data.index);
    case (data.json.Chars[data.index]) of
      '0', '1', '2', '3', '4', '5',
      '6', '7', '8', '9', '-', '+',
      '.', 'e', 'E':
          continue;
    end;

    break;
  end;

  strNum := data.json.Substring(start, data.index - start);

  if (Double.TryParse(strNum, num)) then
  begin
    Result := TJsonValue.Create(TJsonType.Number, num);
  end
  else
  begin
    raise Exception.CreateFmt('Json ParseNumber error, can not parse string [%s]', [strNum]);
  end;
end;

class function TJson.ParseObject(data: TData): TJsonValue;
var
  jsonObject: TDictionary<string, TJsonValue>;
  start: Integer;
  key: string;
begin
  jsonObject := TObjectDictionary<string, TJsonValue>.Create(JsonObjectInitCapacity);

  // skip '{'
  Inc(data.index);

  while (true) do
  begin

    SkipWhiteSpace(data);

    if (data.Json.Chars[data.index] = '}') then
    begin
      break;
    end;

    TDebugTool.Assert
      (
      data.Json.Chars[data.index] = '"',
      'Json ParseObject error, char ''%s'' should be ''"'' ',
      [data.Json.Chars[data.index]]
      );

    // skip '"'
    Inc(data.index);

    start := data.index;

    while (true) do
    begin
      Inc(data.index);
      case (data.json.Chars[data.index-1]) of
        // check end '"'
        '"':
          break;

        '\':
          begin
            // skip escaped quotes
            Inc(data.index);
            continue;
          end;

      else
        continue;
      end;

      // already skip the end '"'
      break;
    end;

    // get object key string
    key := data.Json.Substring(start, data.index - start - 1);

    SkipWhiteSpace(data);

    TDebugTool.Assert
      (
      data.json.Chars[data.index] = ':',
      'Json ParseObject error, after key = %s, char ''%s'' should be '':'' ',
      [key, data.json.Chars[data.index]]
      );

    // skip ':'
    Inc(data.index);

    // set JsonObject key and value
    jsonObject.Add(key, ParseValue(data));

    SkipWhiteSpace(data);

    if (data.json.Chars[data.index] = ',') then
    begin
      Inc(data.index);
    end
    else
    begin
      TDebugTool.Assert
        (
        data.json.Chars[data.index] = '}',
        'Json ParseObject error, after key = %s, char ''%s'' should be ''}'' ',
        [key, data.json.Chars[data.index]]
        );

      break;
    end;
  end;

  // skip '}' and return after '}'
  Inc(data.index);

  Result := TJsonValue.Create(TJsonType.Object, jsonObject);
end;

class function TJson.ParseString(data: TData): TJsonValue;
var
  start: Integer;
  str: string;
  escapedIndex: Integer;
  c: Char;
begin
  // skip '"'
  Inc(data.index);

  start := data.index;

  while (true) do
  begin
    Inc(data.index);
    case (data.json.Chars[data.index-1]) of
      // check string end '"'
      '"':
        begin
          if (data.sb.Length = 0) then
          begin
            // no escaped char just Substring
            str := data.Json.Substring(start, data.index - start - 1);
          end
          else
          begin
            str := data.sb.Append(data.Json, start, data.index - start - 1).ToString;
            // clear for next string
            data.sb.Length := 0;
          end;
        end;

      // check escaped char
      '\':
        begin
          escapedIndex := data.index;
          Inc(data.index);
          case (data.json.Chars[data.index]) of
            '"':
              begin
                c := '"';
              end;

            '\':
              begin
                c := '\';
              end;

            '/':
              begin
                c := '/';
              end;

            '''':
              begin
                c := '''';
              end;

            'b':
              begin
                c := #8; // '\b';
              end;

            'f':
              begin
                c := #12; // '\f';
              end;

            'n':
              begin
                c := #10; // '\n';
              end;

            'r':
              begin
                c := #13; // '\r';
              end;

            't':
              begin
                c := #9; // '\t';
              end;

            'u':
              begin
                c := GetUnicodeCodePoint
                  (
                  data.json.Chars[data.index],
                  data.json.Chars[data.index + 1],
                  data.json.Chars[data.index + 2],
                  data.json.Chars[data.index + 3]
                  );

                // skip code point
                Inc(data.index, 4);
              end;

          else
            // not support just add in pre string
            continue;
          end;

          // add pre string and escaped char
          data.sb.Append(data.Json, start, escapedIndex - start - 1).Append(c);

          // update pre string start index
          start := data.index;
          continue;
        end;

    else
      continue;
    end;

    // already skip the end '"'
    break;
  end;

  Result := TJsonValue.Create(TJsonType.String, TStringValue.Create(str));
end;

class function TJson.ParseValue(data: TData): TJsonValue;
begin
  SkipWhiteSpace(data);

  case (data.Json.Chars[data.index]) of
    '{':
      Exit(ParseObject(data));

    '[':
      Exit(ParseArray(data));

    '"':
      Exit(ParseString(data));

    '0', '1','2', '3', '4', '5', '6', '7', '8', '9', '-':
      Exit(ParseNumber(data));

    'f':
      begin
        if
          (
          (data.json.Chars[data.index + 1] = 'a') and
          (data.json.Chars[data.index + 2] = 'l') and
          (data.json.Chars[data.index + 3] = 's') and
          (data.json.Chars[data.index + 4] = 'e')
          ) then
        begin
          Inc(data.index, 5);
          Exit(TJsonValue.Create(TJsonType.Bool, 0.0));
        end;
      end;

    't':
      begin
        if
          (
          (data.json.Chars[data.index + 1] = 'r') and
          (data.json.Chars[data.index + 2] = 'u') and
          (data.json.Chars[data.index + 3] = 'e')
          ) then
        begin
          Inc(data.index, 4);
          Exit(TJsonValue.Create(TJsonType.Bool, 1.0));
        end
      end;

    'n':
      begin
        if
        (
        (data.json.Chars[data.index + 1] = 'u') and
        (data.json.Chars[data.index + 2] = 'l') and
        (data.json.Chars[data.index + 3] = 'l')
        ) then
        begin
          Inc(data.index, 4);
          Exit(TJsonValue.Create(TJsonType.Null, nil));
        end;
      end;
  end;

  raise Exception.CreateFmt
  (
  'Json ParseValue error on char ''%s'' index at ''%d'' ',
  [data.json.Chars[data.index], data.index]
  );
end;

class procedure TJson.SkipWhiteSpace(data: TData);
begin
  while (true) do
  begin
    case (data.json.Chars[data.index]) of
      ' ' , #9, #10, #13:
      begin
        Inc(data.index);
        Continue;
      end;
    end;

    break;
  end;
end;

class function TJson.UnicodeCharToInt(c: Char): Integer;
begin
  case (c) of
    '0':
      Exit(0);
    '1':
      Exit(1);
    '2':
      Exit(2);
    '3':
      Exit(3);
    '4':
      Exit(4);
    '5':
      Exit(5);
    '6':
      Exit(6);
    '7':
      Exit(7);
    '8':
      Exit(8);
    '9':
      Exit(9);
    'A', 'a':
      Exit(10);
    'B', 'b':
      Exit(11);
    'C', 'c':
      Exit(12);
    'D', 'd':
      Exit(13);
    'E', 'e':
      Exit(14);
    'F', 'f':
      Exit(15);
  end;

  raise Exception.CreateFmt('Json Unicode char ''%s'' error', [c]);
end;

end.
