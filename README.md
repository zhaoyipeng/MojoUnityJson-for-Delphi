## MojoUnityJson for Delphi v1.0

MojoUnityJson for Delphi is an extremely simple and super fast JSON parser for Delphi that tranlated from c# version.

The c# version can be found at:

https://github.com/scottcgi/MojoUnityJson

## License
MojoUnityJson for Delphi is licensed under the [MIT License](LICENSE).

## How to use

* #### Parsing Json string

  ```pascal
  var jsonValue: TJsonValue;
  jsonValue := TJson.Parse(jsonString);
  ```
  
* #### TJsonValue API

  * ##### TJsonValue is string
  
    ```pascal
    function AsString: string;
    ```
    
  * ##### TJsonValue is float
  
    ```pascal
    function AsFloat: Float;
    ```
    
  * ##### TJsonValue is int

    ```pascal
    function AsInt: Integer;
    ```
    
  * ##### TJsonValue is bool
  
    ```pascal
    function AsBool: Boolean;
    ```
    
  * ##### TJsonValue is null
  
    ```pascal
    function IsNull: Boolean;
    ```  

  * ##### TJsonValue is JsonObject
  
    ```pascal
    /// Get the JsonObject, that is a set of k-v pairs, and each value is TJsonValue.
    function AsObject: TDictionary<string, TJsonValue>;
    
    /// Get the TJsonValue from JsonObject by key.
    function AsObjectGet(const key: string): TJsonValue;
    
    /// Get the JsonObject from JsonObject by key.
    function AsObjectGetObject(const key: string): TDictionary<string, TJsonValue>;
    
    /// Get the JsonArray from JsonObject by key.
    function AsObjectGetArray(const key: string): TList<TJsonValue> ;
    
    /// Get the string from JsonObject by key.
    function AsObjectGetString(const key: string): string;
    
    /// Get the float from JsonObject by key.
    function AsObjectGetFloat(const key: string): Float;
    
    /// Get the int from JsonObject by key.
    function AsObjectGetInt(const key: string): Integer;
    
    /// Get the bool from JsonObject by key.
    function AsObjectGetBool(const key: string): Boolean;
    
    /// Get the null from JsonObject by key.  
    function AsObjectGetIsNull(const key: string): Boolean;
    ```
    
  * ##### TJsonValue is JsonArray
  
    ```pascal
    /// Get the JsonArray, that is TJsonValue list.
    function AsArray: TList<TJsonValue> ;
    
    /// Get the TJsonValue from JsonArray at index.
    function AsArrayGet(index: Integer): TJsonValue;
    
    /// Get the JsonObject from JsonArray at index.
    function AsArrayGetObject(index: Integer): TDictionary<string, TJsonValue> ;
    
    /// Get the JsonArray from JsonArray at index.
    function AsArrayGetArray(index: Integer): TList<TJsonValue> ;
    
    /// Get the string from JsonArray at index. 
    function AsArrayGetString(index: Integer): string;
    
    /// Get the float from JsonArray at index.
    function AsArrayGetFloat(index: Integer): Float;
    
    /// Get the int from JsonArray at index.
    function AsArrayGetInt(index: Integer): Integer;
    
    /// Get the bool from JsonArray at index.
    function AsArrayGetBool(index: Integer): Boolean;
    
    /// Get the null from JsonArray at index.
    function AsArrayGetIsNull(index: Integer): Boolean;
    ```
    
