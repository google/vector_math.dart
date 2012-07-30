
class BuiltinTest extends BaseTest {
  void testMix() {
    List<Dynamic> inputA = new List<Dynamic>();
    List<Dynamic> inputB = new List<Dynamic>();
    List<Dynamic> inputC = new List<Dynamic>(); 
    List<Dynamic> expectedOutput = new List<Dynamic>();
    
    inputA.add(parseVector('''0.0 0.0 0.0'''));
    inputA.add(parseVector('''0.0
0.0
0.0'''));
    inputA.add(parseVector('''0.0 
0.0
 0.0'''));
    inputB.add(parseVector('''1.0 
1.0
 1.0'''));
    inputB.add(parseVector('''1.0 
1.0 
1.0'''));
    inputB.add(parseVector('''1.0 
1.0 
1.0'''));
    inputC.add(parseVector('''0.5 
0.5 
0.5'''));
    inputC.add(0.5);
    inputC.add(0.75);
    expectedOutput.add(parseVector('''0.5
0.5 
0.5'''));
    expectedOutput.add(parseVector('''0.5 
0.5 
0.5'''));
    expectedOutput.add(parseVector('''0.75 
0.75 
0.75'''));
    
    assert(inputA.length == inputB.length);
    assert(inputB.length == inputC.length);
    assert(inputB.length == expectedOutput.length);
    for (int i = 0; i < inputA.length; i++) {
      Dynamic out = mix(inputA[i], inputB[i], inputC[i]);
      relativeTest(out, expectedOutput[i]);
    }
  }
  
  void test() {
    print('Running builtin tests');
    testMix();
  }
}
