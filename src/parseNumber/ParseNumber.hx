package parseNumber;

abstract ParseNumber( String ) to String {
    public inline function new( v: String ){
        this = parse( v );
    }
    public inline function isValid(): Bool {
        return !(this == 'NaN');
    }
    @:to
    public inline function toFloat(){
        return parseFloat( this );
    }
    @:to
    public inline function toInt(){
        return parseInt( this );
    }
    public inline function about(){
        parseTest( this );
    }
    public inline static function fromArray( arr: Array<String> ){
        var out = new Array<ParseNumber>();
        return [ for( i in 0...arr.length ) new ParseNumber( arr[ i ] ) ];
    }
}

function parseTest( no: String ){
    trace( "result '" + parse( no ) + "'" );
}

function parseFloat( no: String ){
    Std.parseFloat( no );
}

function parseInt( no: String ){
    Std.parseFloat( no );
}
// scientific exponent notation not setup/available.
function parse( no: String ){
    var str = new StringCodeIterator( no );
    var temp: String = '';
    var count = 0;
    var isNumber = true;
    var dotCount = 0;
    var hasX = false;
    str.next();
    while( str.hasNext() ){
        //trace( str.c );
        if( count == 0 ){
            // trim front 
            if( str.c == ' '.code ){
                count = 0;
                str.next();
                continue;
            }else if( str.c == '-'.code ){
                str.addChar();
                str.next();
                count++;
                continue;
            } else {}
        }
        
        if( count == 1 ){
            if( ( str.c == 'x'.code || str.c == 'X'.code )
                && str.toStr() == '0' ){
                str.addChar();
                str.next();
                hasX = true;
                count++;
                continue;
            } else {
                if( str.toStr() == '0' && str.c != '.'.code )
                {
                    // remove a leading 0
                    @:privateAccess  str.b = new StringBuf();
                }
            }
        }
        switch( str.c ) {
            case '.'.code:
                if( dotCount == 0 && !hasX ){
                    str.addChar();
                } else {
                    isNumber = false;
                    break;
                }
                dotCount++;
            case '0'.code
                ,'1'.code
                ,'2'.code
                ,'3'.code
                ,'4'.code
                ,'5'.code
                ,'6'.code
                ,'7'.code
                ,'8'.code
                ,'9'.code
                :
                str.addChar();
            case 'a'.code
                ,'b'.code
                ,'c'.code
                ,'d'.code
                ,'e'.code
                ,'f'.code
                ,'A'.code
                ,'B'.code
                ,'C'.code
                ,'D'.code
                ,'E'.code
                ,'F'.code
                :
                if( hasX ) {
                    if( count < 11 ){
                        str.addChar();
                    } else {
                        str.addChar();
                        //trace( 'hex too long?' );
                    }
                } else {
                    isNumber = false;
                    break;
                }
            case ' '.code:
                // trim end
                while( str.hasNext() ){
                    if( str.c != ' '.code ){
                            isNumber = false;
                            break;
                    }
                    str.next();
                }
                break;
            default: 
                //trace( 'found bad char ' + str.c );
                isNumber = false;
                break;
        } 
        count++;
        str.next();
    }
    if( count == 0 ){
        isNumber = false;
    }
    return if( isNumber ){
        str.toStr();
    } else {
        'NaN';
    }
}
