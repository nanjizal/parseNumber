# parseNumber

#### Simple function and abstract to allow checking if a String is a valid number ( Float or Int ).

```Screen shot from the utest output using haxedox.  ```
  
<img width="769" alt="testParseNumber" src="https://user-images.githubusercontent.com/20134338/150689456-02a4784a-b516-4c6a-a9cc-53f44af58782.png">


```Haxe
var no: ParseNumber = '0.1';
trace( no.isValid() );
var f: Float = no;
```

```Haxe
import ParseNumber;
function main(){
parseTest( ' 0.0.1 ' );
}
```
view haxe js test here.

https://nanjizal.github.io/parseNumber/bin/main.html
