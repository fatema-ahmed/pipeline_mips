#include<iostream>
#include<fstream>
#include<string>
#include<cstdlib>
#include<vector>
#include<iomanip>
#include<algorithm>
using namespace std;


//空指令：NOP
//存储访问指令：LW, SW, LUI；
//算术逻辑指令：add, addu, sub, subu, addi, addiu, and, or, xor, nor, andi, sll, srl, sra, slt, slti, sltiu；
//分支和跳转指令branch(beq, bne, blez, bgtz, bltz)和jump(j, jal, jr, jalr)；
//Type==-1: ERROR;
//Type==0: NOP;
//Type==1: reg, reg, reg--------add, addu, sub, subu, and, or, xor, nor, slt
//Type==2: reg, reg, imm--------addi, addiu, andi, sll, srl, sra, slti, sltiu, beq, bne, LW, SW
//Type==3: reg, imm--------blez, bgtz, bltz, LUI
//Type==4: reg--------jr
//Type==5: reg, reg--------jalr
//Type==6: imm--------j, jal

//ref: http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html
//ref: Computer Organization and Design v3.0 (P53)

struct Sentence
{
	int LineNumber;
	string function;
	string A;
	string B;
	string C;
	int labelIndex;
	int Type;
};

struct Label
{
	int LineNumber;
	string Name;
};

ifstream fin("input.txt");
ofstream fout("output.txt");

vector<Sentence> Lines;
vector<Label> Labels;
vector<unsigned int> final;
int lineCount=0;
int labelCount=0;



int StringToReg(string t)
{
	if(t[0]!='$')
		return 0;
	if(t=="$zero")
		return 0;
	if(t=="$gp")
		return 28;
	if(t=="$sp")
		return 29;
	if(t=="$fp")
		return 30;
	if(t=="$ra")
		return 31;
	if(t[1]=='v')
	{
		if(t[2]=='0')
			return 2;
		else if(t[2]=='1')
			return 3;
		else
			return 0;
	}
	else if(t[1]=='a')
		return 4+t[2]-'0';
	else if(t[1]=='s')
		return 16+t[2]-'0';
	else if(t[1]=='t')
	{
		int temp=t[2]-'0';
		if(temp<8)
			return 8+temp;
		else
			return 16+temp;
	}
	else
		return 0;
}

int StringToImm(string t)
{
	for(int i=0;i<t.length();i++)
	{
		if(t[i]<'0'||t[i]>'9')
			return 0;
	}
	return atoi(t.c_str());
}

unsigned int GetJumpAddress(string L)
{
	for(vector<Label>::iterator i=Labels.begin();i<Labels.end();i++)
	{
		if(i->Name==L)
			return i->LineNumber;
	}
	return 0;
}

unsigned int TranslateType1(vector<Sentence>::iterator it)
//Type==1: reg, reg, reg--------add, addu, sub, subu, and, or, xor, nor, slt
{
	int a,b,c;
	unsigned int result=0;
	a=StringToReg(it->A);
	b=StringToReg(it->B);
	c=StringToReg(it->C);
	if(a>31||a<0)
		return 0;
	if(b>31||b<0)
		return 0;
	if(c>31||c<0)
		return 0;

	int ALUOP=0;
	if(it->function=="add")
		ALUOP=32;
	else if(it->function=="addu")
		ALUOP=33;
	else if(it->function=="sub")
		ALUOP=34;
	else if(it->function=="subu")
		ALUOP=35;
	else if(it->function=="and")
		ALUOP=36;
	else if(it->function=="or")
		ALUOP=37;
	else if(it->function=="xor")
		ALUOP=38;
	else if(it->function=="nor")
		ALUOP=39;
	else if(it->function=="slt")
		ALUOP=42;
	else
		return 0;
	result+=b;
	result<<=5;
	result+=c;
	result<<=5;
	result+=a;
	result<<=11;
	result+=ALUOP;
	return result;
}

unsigned int TranslateType2(vector<Sentence>::iterator it)
//Type==2: reg, reg, imm--------addi, addiu, beq, bne, andi, slti, sltiu, LW, SW// sll, srl, sra
{
	unsigned int result=0;
	if(it->function=="addi"||it->function=="addiu"||it->function=="andi"||it->function=="beq"||it->function=="bne"||
		it->function=="slti"||it->function=="sltiu"||it->function=="sw"||it->function=="lw")
	{
		int OP=0;
		if(it->function=="addi")
			OP=8;
		else if(it->function=="addiu")
			OP=9;
		else if(it->function=="andi")
			OP=12;
		else if(it->function=="beq")
			OP=4;
		else if(it->function=="bne")
			OP=5;
		else if(it->function=="slti")
			OP=10;
		else if(it->function=="sltiu")
			OP=11;
		else if(it->function=="sw")
			OP=43;
		else if(it->function=="lw")
			OP=35;
		else
			return 0;

		if(it->function=="bne"||it->function=="beq")     //bne $a1 $a2 -10
		{
			int a,b;
			__int16 c;
			a=StringToReg(it->A);
			b=StringToReg(it->B);
			c=GetJumpAddress(it->C)-1-(__int16)it->LineNumber;

			if(a>31||a<0)
				return 0;
			if(b>31||b<0)
				return 0;

			result+=OP;
			result<<=5;
			result+=a;
			result<<=5;
			result+=b;
			result<<=16;
			result+=c;
			return result;
		}
		else
		{
			int a,b,c;
			a=StringToReg(it->A);
			b=StringToReg(it->B);
			c=StringToImm(it->C);

			if(a>31||a<0)
				return 0;
			if(b>31||b<0)
				return 0;
			if(c>65535||c<0)
				return 0;

			result+=OP;
			result<<=5;
			result+=b;
			result<<=5;
			result+=a;
			result<<=16;
			result+=c;
			return result;
		}
	}
	// sll, srl, sra
	else if(it->function=="sll"||it->function=="srl"||it->function=="sra"||it->function=="beq"||it->function=="bne")
	{
		int funct=0;
		if(it->function=="sll")
			funct=0;
		else if(it->function=="srl")
			funct=2;
		else if(it->function=="sra")
			funct=3;
		else
			return 0;

		int a,b,c;
		a=StringToReg(it->A);
		b=StringToReg(it->B);
		c=StringToImm(it->C);
		if(a>31||a<0)
			return 0;
		if(b>31||b<0)
			return 0;
		if(c>31||c<0)
			return 0;

		result+=b;
		result<<=5;
		result+=a;
		result<<=5;
		result+=c;
		result<<=6;
		result+=funct;

		return result;
	}
	else
		return 0;
}

unsigned int TranslateType3(vector<Sentence>::iterator it)
//Type==3: reg, imm--------blez, bgtz, bltz, LUI
{
	unsigned int result=0;
	if(it->function=="lui")
	{
		int a,c;
		a=StringToReg(it->A);
		c=StringToImm(it->B);
		if(a>31||a<0)
			return 0;
		if(c>65535||c<0)
			return 0;

		result+=15;
		result<<=10;
		result+=a;
		result<<=16;
		result+=c;

		return result;
	}
	else if(it->function=="blez"||it->function=="bgtz"||it->function=="bltz")
	{
		int OP=0;
		if(it->function=="blez")
			OP=6;
		else if(it->function=="bgtz")
			OP=7;
		else if(it->function=="bltz")
			OP=1;
		else
			return 0;

		int a;
		__int16 c;
		a=StringToReg(it->A);
		c=GetJumpAddress(it->B)-1-(__int16)it->LineNumber;
		if(a>31||a<0)
			return 0;

		result+=OP;
		result<<=5;
		result+=a;
		result<<=21;
		if(c>0)
			result+=c;
		else
			result=result+c+65536;

		return result;
	}
	else
		return 0;
}

unsigned int TranslateType4(vector<Sentence>::iterator it)
//Type==4: reg--------jr
{
	unsigned int result=0;
	if(it->function=="jr")
	{
		int a;
		a=StringToReg(it->A);
		if(a>31||a<0)
			return 0;

		result+=a;
		result<<=21;
		result+=8;

		return result;
	}
	else
		return 0;
}

unsigned int TranslateType5(vector<Sentence>::iterator it)
//Type==5: reg, reg--------jalr
{
	unsigned int result=0;
	if(it->function=="jalr")
	{
		int a,b;
		a=StringToReg(it->A);
		b=StringToReg(it->B);
		if(a>31||a<0)
			return 0;
		if(b>31||b<0)
			return 0;

		result+=a;
		result<<=10;
		result+=b;
		result<<=11;
		result+=9;

		return result;
	}
	else
		return 0;
}

unsigned int TranslateType6(vector<Sentence>::iterator it)
//Type==6: imm--------j, jal
{
	unsigned int result=0;
	if(it->function=="j"||it->function=="jal")
	{
		int OP=0;
		if(it->function=="j")
			OP=2;
		else if(it->function=="jal")
			OP=3;
		else
			return 0;

		int a;
		a=GetJumpAddress(it->A);
		if(a>67108863||a<0)
			return 0;

		result+=OP;
		result<<=26;
		result+=a;

		return result;
	}
	else
		return 0;
}

unsigned int Translate(vector<Sentence>::iterator it)
{
	if(it->Type==-1)
		return 0;
	if(it->Type==0)
		return 0;
	if(it->Type==1)
	{
		return TranslateType1(it);
	}
	else	if(it->Type==2)
	{
		return TranslateType2(it);
	}
	else	if(it->Type==3)
	{
		return TranslateType3(it);
	}
	else	if(it->Type==4)
	{
		return TranslateType4(it);
	}
	else	if(it->Type==5)
	{
		return TranslateType5(it);
	}
	else	if(it->Type==6)
	{
		return TranslateType6(it);
	}
	else
		return 0;
}

void print32(unsigned int number)
{
	int result[32];
	for(int i=0;i<32;i++)
		result[i]=0;
    unsigned int temp = number;
    unsigned int num;
    int i=0;
    while(temp !=0)
    {
        num = temp%2;
        result[i] = num;
        i++;
        temp = temp/2;
    }
    for(i=31;i>=0;i--)
    {
        fout<<result[i];
		//cout<<result[i];
    }
}

int main()
{
	bool flag=false;//record if there is a label before
	while(!fin.eof())
	{
		string t0, t1;
		flag=false;
		fin>>t0;
		if(t0[t0.length()-1]==':')
		{
			t0=t0.substr(0,t0.length()-1);
			Label tlabel;
			tlabel.LineNumber = lineCount;
			labelCount++;
			tlabel.Name=t0;
			Labels.push_back(tlabel);
			flag=true;
			fin>>t0;//replace label, load function
		}		
		
		Sentence temp;
		temp.labelIndex = -1;
		if(flag)
			temp.labelIndex = labelCount-1;
		temp.Type = -1;
		temp.LineNumber = lineCount++;

		//Type==1: reg, reg, reg--------add, addu, sub, subu, and, or, xor, nor, slt,
		if(t0=="add"||t0=="addu"||t0=="sub"||t0=="subu"||t0=="and"||t0=="or"||t0=="xor"||
			t0=="nor"||t0=="slt")	
		{
			temp.Type=1;
			temp.function=t0;
			fin>>temp.A>>temp.B>>temp.C;
		}
		//Type==2: reg, reg, imm--------addi, addiu, andi, sll, srl, sra, slti, sltiu, beq, bne, LW, SW
		else if(t0=="sw"||t0=="lw"||t0=="addi"||t0=="addiu"||t0=="andi"||t0=="slti"||t0=="sltiu"||
			t0=="beq"||t0=="bne"||t0=="sll"||t0=="srl"||t0=="sra")
		{
			temp.Type=2;
			temp.function=t0;
			fin>>temp.A;
			if(t0=="lw"||t0=="sw")
			{
				fin>>t1;
				int location1 = t1.find('(',0);
				int location2 = t1.find(')',0);
				temp.C = t1.substr(0,location1);
				temp.B = t1.substr(location1+1, location2-location1-1);
			}
			else
				fin>>temp.B>>temp.C;
		}
		//Type==3: reg, imm--------blez, bgtz, bltz, LUI
		else if(t0=="blez"||t0=="bgtz"||t0=="bltz"||t0=="lui")
		{
			temp.Type=3;
			temp.function=t0;
			fin>>temp.A>>temp.B;
			temp.C="";
		}
		//Type==4: reg--------jr
		else if(t0=="jr")
		{
			temp.Type=4;
			temp.function=t0;
			fin>>temp.A;
			temp.B=temp.C="";
		}
		//Type==5: reg, reg--------jalr
		else if(t0=="jalr")
		{
			temp.Type=5;
			temp.function=t0;
			fin>>temp.A>>temp.B;
			temp.C="";
		}
		//Type==6: imm--------j, jal
		else if(t0=="jal"||t0=="j")
		{
			temp.Type=6;
			temp.function=t0;
			fin>>temp.A;
			temp.B=temp.C="";
		}
		//Type==0: NOP;
		else if(t0=="NOP")
		{
			temp.Type=0;
			temp.function=t0;
			temp.A=temp.B=temp.C="";
		}
		//Type==-1: ERROR;
		else
		{
			temp.Type=-1;//error
			temp.function=t0;
			temp.A=temp.B=temp.C="";
		}
		Lines.push_back(temp);
	}

	
	for(vector<Sentence>::iterator i = Lines.begin();i!=Lines.end();i++)
	{
		final.push_back(Translate(i));
	}

	int p=0;
	for(vector<unsigned int>::iterator i = final.begin();i!=final.end();i++)
	{
		fout<<p++<<": data<= 32'b";
		print32(*i);
		fout<<";"<<endl;
	}
	



	fin.close();
	fout.close();
	return 0;
}
