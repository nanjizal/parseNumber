# parseNumber

Simple function and abstract to allow checking if a String is a valid number ( Float or Int ).

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

https://nanjizal.github.io/parseNumber/main.html
