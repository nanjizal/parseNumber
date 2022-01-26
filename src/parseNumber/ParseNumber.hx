package parseNumber;

abstract ParseNumber( String ) to String {
    public inline function new( v: String ){
        this = parse( v, true, true, true );
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

function parseTest( no: String, allowComma = false, allowUnderscore = false, allowScientific = false ){
    trace( "result '" + parse( no ) + "'" );
}

function parseFloat( no: String ){
    Std.parseFloat( no );
}

function parseInt( no: String ){
    Std.parseFloat( no );
}
    /**
     * <pre><code>
     * >>> ({ 
     * ... trace( 'trimming start and end spaces " -100.000 " = ' +  parse(' -100.000 '));
     * ... var no: String = parse(' -100.000 ');
     * ... no == '-100.000'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'acceptance of hex number "0xFFFF00" = ' + parse('0xFFFF00'));
     * ... var no: String = parse('0xFFFF00');
     * ... no == '0xFFFF00'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'removal of leading zeros "  01" = ' + parse('  01'));
     * ... var no: String = parse('  01');
     * ... no == '1'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'not allowing multiple dots "1.2.3" = ' + parse('1.2.3'));
     * ... var no: String = parse('1.2.3');
     * ... no == 'NaN'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'stripping out underscores and commas needs allowComma, allowUnderscore "1,2_3" = ' + parse('1,2_3', true, true ));
     * ... var no: String = parse('1,2_3',true, true);
     * ... no == '123'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'not allowing negative symbol within number "800-83b9" = ' + parse('800-83b9'));
     * ... var no: String = parse('800-83b9');
     * ... no == 'NaN'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'not accepting hex numbers above ARGB "0xffFFffFFf" = ' + parse('0xffFFffFFf', false, false, true ));
     * ... var no: String = parse('0xffFFffFFf');
     * ... no == 'NaN'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'testing scientific, need to set allowScientific "123e5" = ' + parse('123e5', false, false,true));
     * ... var no: String = parse('123e5', false, false, true);
     * ... no == '123e5'; }) == true
     * </code></pre>
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'testing scientific, need to set allowScientific "123e-5 " = ' + parse('123e-5 ',false, false, true));
     * ... var no: String = parse('123e-5 ', false, false, true);
     * ... no == '123e-5'; }) == true
     * </code></pre>
     *
     * 
     * <pre><code>
     * >>> ({ 
     * ... trace( 'testing scientific, need to set allowScientific "123e-5 e" = ' + parse('123e-5 e',true));
     * ... var no: String = parse('123e-5 e', false, false, true);
     * ... no == 'NaN'; }) == true
     * </code></pre>
     */
function parse( no: String, allowComma = false, allowUnderscore = false, allowScientific = false ){
    var str = new StringCodeIterator( no );
    var temp: String = '';
    var count = 0;
    var isNumber = true;
    var dotCount = 0;
    var hasX = false;
    var isScientific = false;
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
        if( str.c == '_'.code && allowUnderscore ){
            str.next();
            continue;
        }
        if( str.c == ','.code && allowComma ){
            str.next();
            continue;
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
                    if( count < ('0xFFffFFf'.length) ){
                        str.addChar();
                    } else {
                        isNumber = false;
                        break;
                        trace( 'hex too long?' );
                    }
                } else if( allowScientific ){
                    // check for scientific exponents
                    // rather heavy 
                    // need to check the rest of the letter before deciding to add e.
                    if( str.c == 'e'.code || str.c == "E".code ) {
                        @:privateAccess  var letters = str.str;
                        var someNumerics = false;
                        var curPos = str.pos;
                        for( i in (str.pos)...letters.length ){
                            var no = StringTools.fastCodeAt( letters, i );
                            curPos = i;
                            switch( no ){
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
                                    someNumerics = true;
                                case '-'.code:
                                    // only allow negative sign just after the e
                                    if( !( i == str.pos ) ){
                                        isNumber = false;
                                        break;
                                    } else {
                                        //'allowing negative' );
                                    }
                                default:
                                    break;
                            }
                        }
                        if( someNumerics == false ){
                            isNumber = false;
                        }
                        if( isNumber == false ) break;
                        for( i in curPos...letters.length ){
                            // with scientific after the number only allow spaces
                            switch( i ){
                                case ' '.code:
                                    // ok :)
                                default:
                                    isNumber == false;
                                    break;
                            }
                        }
                        if( isNumber == false ) {
                            break;
                        } else {
                            // allow e and continue normally.
                            isScientific = true;
                            str.addChar();
                        }
                    } else {
                        isNumber = false;
                        break;
                    }
                } else {
                    isNumber = false;
                    break;
                }
            case '-'.code:
                if( isScientific == true ){
                    str.addChar();
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
