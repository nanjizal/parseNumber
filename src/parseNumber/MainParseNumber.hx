package parseNumber;
import parseNumber.ParseNumber;
import htmlHelper.tools.DivertTrace;
function main(){
    trace( 'Testing parseValues' );
    new DivertTrace();
    var testValues: Array<String> = [ '-100.000'
                    , 'test'
                    , '0xFF0000'
                    , '  01'
                    , '  2.2  ' 
                    , '1.2.3'
                    , "800-83b9" ];
    var parseValues = ParseNumber.fromArray( testValues );
    
    for( value in parseValues ){
        trace( value );
    }
    
    for( value in testValues ){
        trace( 'testing "' + value +'"');
        parseTest( value ); 
    }
    
}
