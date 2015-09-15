
struct F { int a; };
struct G { int b; int c; };
struct H { F d; int e; };


int main(){

	F myF;
	G myG;
	H myH;

	myF.a = 2;
	myG.b = 3;	myG.c = 4;
	myH.d.a = 5;	myH.e = 6;
	
	for(int i =0; i< 100; ++i){
		myH.d.a = i;
		
	}

	return 0;
}
