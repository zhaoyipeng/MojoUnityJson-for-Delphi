program Demo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  MojoUnity.Json in 'MojoUnity.Json.pas';

const
  json: string = '{ "ID": "id1", "Name": "John", "Age": 18, "Sex": true }';
  json_array: string =
    '[ ' +
    '{ "ID": "id1", "Name": "John", "Age": 18, "Sex": true }, '+
    '{ "ID": "id2", "Name": "Mike", "Age": 20, "Sex": false } '+
    ']';
var
  jsonValue: TJsonValue;
  I: Integer;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    jsonValue := TJson.Parse(json);
    Writeln('=========================');
    Writeln('parse json: ', json);
    Writeln('=========================');
    Writeln('ID  : ', jsonValue.AsObjectGetString('ID'));
    Writeln('Name: ', jsonValue.AsObjectGetString('Name'));
    Writeln('Age : ', jsonValue.AsObjectGetInt('Age'));
    Writeln('Sex : ', jsonValue.AsObjectGetBool('Sex'));
    jsonValue.Free;

    jsonValue := TJson.Parse(json_array);
    Writeln('=========================');
    Writeln('parse array: ', json_array);
    Writeln('=========================');
    for I := 0 to jsonValue.AsArray.Count-1 do
    begin
      Writeln('Object [', I, ']');
      Writeln('-------------------------');
      Writeln('ID  : ', jsonValue.AsArrayGetObject(I).Items['ID'].AsString);
      Writeln('Name: ', jsonValue.AsArrayGetObject(I).Items['Name'].AsString);
      Writeln('Age : ', jsonValue.AsArrayGetObject(I).Items['Age'].AsInt);
      Writeln('Sex : ', jsonValue.AsArrayGetObject(I).Items['Sex'].AsBool);
      Writeln('=========================');
    end;
    jsonValue.Free;
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
