import "dart:io";
void main() {
  for (var i = 0; i < 10; i++) {
    print('hello ${i + 1}');
  }
  stdout.write("enter your name:");
  var name=stdin.readLineSync();
  print("Welcome, $name");
  var so=Sol();
  so.add(1,4);
}
class Sol{
  void add(int a,int b){
    print(a+b);
  }
}