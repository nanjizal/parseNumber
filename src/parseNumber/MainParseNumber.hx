package parseNumber;
import parseNumber.ParseNumber;
#if js
import htmlHelper.tools.DivertTrace;
#end
function main(){
    trace( 'Testing parseValues' );
    #if js
    new DivertTrace();
    #end
    var testValues: Array<String> = [ '-100.000'
                    , 'test'
                    , '0xFF0000'
                    , '  01'
                    , '  2.2  ' 
                    , '1.2.3'
                    , "800-83b9"
                    , "1_00_1" 
                    , "1,2_3"
                    , "0xFFffFFffF" ];
    var parseValues = ParseNumber.fromArray( testValues );
    /*
    for( value in parseValues ){
        trace( value );
    }
    */
    for( value in testValues ){
        trace( 'testing "' + value +'"');
        parseTest( value ); 
    }
    
    trace( 'test Scientific' );
    trace( '123e5 = ' + parse( '123e5', true ) );
    trace( '123e-5 = ' + parse( '123e-5', true ) );
    trace( '123e-5 e = ' + parse( '123e-5 e', true ) );
}
