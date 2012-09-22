#import('dart:core');
#import('../lib/vector_math_console.dart');

typedef int Benchmark(int count);

class BenchmarkResult {
  int minTicks;
  int maxTicks;
  int avgTicks;
  String name;
  
  BenchmarkResult(this.name) {
    minTicks = 0;
    maxTicks = 0;
    avgTicks = 0;
  }
  
  static num convertToMicroseconds(int i) {
    Stopwatch sw = new Stopwatch();
    assert(sw.frequency() == 1000000);
    num o = i;
    return o;
  }
  
  static num convertToMilliseconds(int i) {
    Stopwatch sw = new Stopwatch();
    assert(sw.frequency() == 1000000);
    num o = i;
    o = o / 1000.0;
    return o;
  }
  
  num get min() {
      return convertToMicroseconds(minTicks);
  }
  
  num get max() {
    return convertToMicroseconds(maxTicks);
  }
  
  num get avg() {
    return convertToMicroseconds(avgTicks);
  }
  
  num get minMS() {
    return convertToMilliseconds(minTicks);
  }

  num get maxMS() {
    return convertToMilliseconds(maxTicks);
  }

  num get avgMS() {
    return convertToMilliseconds(avgTicks);
  }
}

class BenchmarkInfo {
  String name;
  Benchmark bench;
  BenchmarkInfo(this.name, this.bench);
}

class BenchmarkRunner {
  static BenchmarkResult Run(BenchmarkInfo bi, int runCount, int innerCount) {
    int i = 0;
    BenchmarkResult r = new BenchmarkResult(bi.name);
    for (i = 0; i < runCount; i++) {
      int ticks = bi.bench(innerCount);
      if (i == 0) {
        r.minTicks = ticks;
        r.maxTicks = ticks;
      } else {
        if (r.minTicks > ticks) {
          r.minTicks = ticks;
        }
        if (r.maxTicks < ticks) {
          r.maxTicks = ticks;
        }
      }
      r.avgTicks += ticks;
    }
    r.avgTicks = r.avgTicks ~/ runCount; 
    return r;
  }
  
  static RunSet(List<BenchmarkInfo> benchs, int runCount, int innerCount) {
    for (BenchmarkInfo bi in benchs) {
      BenchmarkResult br = BenchmarkRunner.Run(bi, runCount, innerCount);
      print('=============================================');
      print('${br.name}');
      print('=============================================');
      print('Dart Vector Math: Avg: ${br.avgMS} ms Min: ${br.minMS} ms Max: ${br.maxMS} ms (Avg: ${br.avgTicks} Min: ${br.minTicks} Max: ${br.maxTicks})');
    }
  }
}

int MatrixMultiply(int count) {
  mat4 matA = new mat4.identity();
  mat4 matB = new mat4.identity();
  Stopwatch sw = new Stopwatch();
  sw.start();
  for (int i = 0; i < count; i++) {
    matA.multiply(matB);
  }
  sw.stop();
  return sw.elapsed();
}

void main() {
  final int runCount = 10;
  final int innerCount = 20000;
  print('Starting benchmark');
  List<BenchmarkInfo> benchmarks = new List<BenchmarkInfo>();
  benchmarks.add(new BenchmarkInfo('Matrix Multiplication', MatrixMultiply));
  BenchmarkRunner.RunSet(benchmarks, runCount, innerCount); 
}