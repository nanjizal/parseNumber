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
view haxe js test here.

https://nanjizal.github.io/parseNumber/bin/main.html

( Not tested beyond js yet. )

Currently it will trim white space, but not allow white space within number.  It does not allow commas, and does not support scientific exponents yet. It will do things like check for more than one dot, and remove any surpflous zeros. If you have specific use case we can tweak a version or add more protection. On some platforms I would hope it will run faster than ereg expressions but not done any speed tests, if you have ereg version can do some tests..
