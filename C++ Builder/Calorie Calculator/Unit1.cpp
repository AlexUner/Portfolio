//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
#include <StrUtils.hpp>
TForm1 *Form1;
int step = 0;
double weight,height,age,p_fat,BMR;
//---------------------------------------------------------------------------
double protein(int n)
{
	switch (n) {
		case 0: return round((BMR*0.1718)/4.0); break;
		case 1: return round((BMR*0.1552)/4.0); break;
		case 2: return round((BMR*0.1438)/4.0); break;
		case 3: return round((BMR*0.1354)/4.0); break;
		case 4: return round((BMR*0.129)/4.0); break;
	}
	return 0;
}
//---------------------------------------------------------------------------
double fat(int n)
{
	switch (n) {
		case 0: return round((BMR*0.2762)/9.0); break;
		case 1: return round((BMR*0.2816)/9.0); break;
		case 2: return round((BMR*0.2854)/9.0); break;
		case 3: return round((BMR*0.2882)/9.0); break;
		case 4: return round((BMR*0.2903)/9.0); break;
	}
	return 0;
}
//---------------------------------------------------------------------------
double calories(int n)
{
	switch (n) {
		case 0: return round((BMR*0.552)/4.0);  break;
		case 1: return round((BMR*0.5632)/4.0); break;
		case 2: return round((BMR*0.5708)/4.0); break;
		case 3: return round((BMR*0.5764)/4.0); break;
		case 4: return round((BMR*0.5806)/4.0); break;
	}
    return 0;
}
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::N1Click(TObject *Sender)
{
	Application->MessageBox(L"1. Нажмите Enter чтобы сделать выбор;\n2. Выбирайте варианты или вводите\n    данные с помощью цифр 1-9;\n3. Вернитесь к предыдущему пункту \n    с помощью Backspace.", L"Инструкция", MB_OK);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormKeyUp(TObject *Sender, WORD &Key, TShiftState Shift)
{
	if (Key == VK_RETURN && step < 8)
	{
		++step;
		if (RadioGroup1->ItemIndex == 2 && step == 5) step = 7;
		Edit1->Text = "";
	}
	else if (Edit1->Text == "" && Key == VK_BACK && step > 0)
	{
		--step;
		if (RadioGroup1->ItemIndex == 2 && step == 6) step = 3;
        Edit1->Text = "";
	}
	if ((step == 8 && RadioGroup1->ItemIndex == 2) || (step == 7 && RadioGroup1->ItemIndex != 2)) {
		if (RadioGroup1->ItemIndex == 2) {
			BMR = 370 + (21.6*((weight*(100.0-p_fat))/100.0));
		} else
		if (RadioGroup1->ItemIndex == 0) {
			if (!RadioGroup2->ItemIndex)
				BMR = 66 + (13.7*weight) + (5*height) - (6.76*age);
			else
				BMR = 655 + (9.6*weight) + (1.8*height) - (6.76*age);
		}
		else {
			if (!RadioGroup2->ItemIndex)
				BMR = (9.99*weight) + (6.25*height) - (4.92*age) + 5;
			else
				BMR = (9.99*weight) + (6.25*height) - (4.92*age) - 161;
		}
		switch (RadioGroup3->ItemIndex) {
			case 0: BMR *= 1.2; break;
			case 1: BMR *= 1.4; break;
			case 2: BMR *= 1.6; break;
			case 3: BMR *= 1.8; break;
			case 4: BMR *= 2; break;
		}
		switch (RadioGroup4->ItemIndex) {
			case 0: BMR -= BMR*0.2; break;
			case 1: BMR -= BMR*0.1; break;
			case 3: BMR += BMR*0.1; break;
			case 4: BMR += BMR*0.2; break;
		}
		UnicodeString Output = "Ваше количество калорий с учетом активности: "+FloatToStr(round(BMR));
		Output += "\nПримерные расчеты БЖУ в граммах.";
		Output += "\nБелки: "+FloatToStr(protein(RadioGroup3->ItemIndex));
		Output += "\nЖиры: "+FloatToStr(fat(RadioGroup3->ItemIndex));
		Output += "\nУглеводы: "+FloatToStr(calories(RadioGroup3->ItemIndex));
		Application->MessageBox(Output.c_str(), L"Итог", MB_OK);
		if (mrYes==Application->MessageBox(L"Повторить вычисления?", L"Повтор", MB_YESNO | MB_ICONQUESTION)) {
			step = -1;
            RadioGroup1->Visible = true;
			RadioGroup2->Visible = false;
            Panel1->Visible = false;
		}
		else
		{
            Close();
		}
	}

	switch (step)
	{
		case 0:
			RadioGroup1->Visible = true;
			RadioGroup2->Visible = false;
			Panel1->Visible = false;
			if (Key == '1') RadioGroup1->ItemIndex = 0;
			if (Key == '2') RadioGroup1->ItemIndex = 1;
			if (Key == '3') RadioGroup1->ItemIndex = 2;
            RadioGroup1->Buttons[RadioGroup1->ItemIndex]->SetFocus();
		break;
		case 1:
			RadioGroup1->Visible = false;
			RadioGroup2->Visible = true;
			RadioGroup4->Visible = false;
			if (Key == '1') RadioGroup2->ItemIndex = 0;
			if (Key == '2') RadioGroup2->ItemIndex = 1;
			RadioGroup2->Buttons[RadioGroup2->ItemIndex]->SetFocus();
		break;
        case 2:
			RadioGroup2->Visible = false;
			RadioGroup4->Visible = true;
			RadioGroup3->Visible = false;
			if (Key == '1') RadioGroup4->ItemIndex = 0;
			if (Key == '2') RadioGroup4->ItemIndex = 1;
			if (Key == '3') RadioGroup4->ItemIndex = 2;
			if (Key == '4') RadioGroup4->ItemIndex = 3;
			if (Key == '5') RadioGroup4->ItemIndex = 4;
			RadioGroup4->Buttons[RadioGroup4->ItemIndex]->SetFocus();
		break;
		case 3:
			RadioGroup4->Visible = false;
			RadioGroup3->Visible = true;
			Panel1->Visible = false;
			if (Key == '1') RadioGroup3->ItemIndex = 0;
			if (Key == '2') RadioGroup3->ItemIndex = 1;
			if (Key == '3') RadioGroup3->ItemIndex = 2;
			if (Key == '4') RadioGroup3->ItemIndex = 3;
			if (Key == '5') RadioGroup3->ItemIndex = 4;
            RadioGroup3->Buttons[RadioGroup3->ItemIndex]->SetFocus();
		break;
		case 4:
			RadioGroup3->Visible = false;
			Panel1->Visible = true;
			Panel1->Caption = "Вес в килограммах";
            Edit1->SetFocus();
		break;
		case 5:
        	Panel1->Caption = "Рост в сантиметрах";
            Edit1->SetFocus();
		break;
		case 6:
        	Panel1->Caption = "Возраст в годах";
            Edit1->SetFocus();
		break;
		case 7:
            RadioGroup3->Visible = false;
			Panel1->Visible = true;
        	Panel1->Caption = "Процент жира";
            Edit1->SetFocus();
		break;
	}
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Edit1Change(TObject *Sender)
{
	Edit1->Text = AnsiReplaceStr(Edit1->Text,".",",");
    Edit1->SelStart = Edit1->Text.Length();

	if (Edit1->Text != "" && Edit1->Visible && step == 4)
		weight = StrToFloat(Edit1->Text);
	if (Edit1->Text != "" && Edit1->Visible && step == 5)
		height = StrToFloat(Edit1->Text);
	if (Edit1->Text != "" && Edit1->Visible && step == 6)
		age = StrToFloat(Edit1->Text);
	if (Edit1->Text != "" && Edit1->Visible && step == 7)
		p_fat = StrToFloat(Edit1->Text);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::N3Click(TObject *Sender)
{
	UnicodeString Output;
	Output = "Формула основана на исследовании,в котором участвовали молодые,\n";
	Output += "ведущие активный образ жизни мужчины в холодных лабораториях много\n";
	Output += "лет назад(1919), и она дает большее количество калорий, чем нужно,\n";
	Output += "особенно в случаях, если у вас лишний вес.";
	Application->MessageBox(Output.c_str(), L"Формула Харриса-Бенедикта", MB_OK | MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::N4Click(TObject *Sender)
{
	UnicodeString Output;
	Output = "Разработана в 90-х годах 20 века. Пожалуй самая популярная формула для\n";
	Output += "расчета необходимого уровня калорий. Больше подходит для сегодняшнего образа\n";
	Output += "жизни и питания. Но и она не берет в расчет разницу между разным процентом\n";
	Output += "жира. Считается, что эта формула тоже завышает потребности в калориях.";
	Application->MessageBox(Output.c_str(), L"Формула Миффлина-Сан Жеора", MB_OK | MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::N5Click(TObject *Sender)
{
	UnicodeString Output;
	Output = "Считается наиболее точной из подобных формул, но для того, чтобы ей\n";
	Output += "воспользоваться, нужно знать свой процент жира.";
	Application->MessageBox(Output.c_str(), L"Формула Кэтча-МакАрдла", MB_OK | MB_ICONINFORMATION);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, System::WideChar &Key)
{
	if(!isdigit(Key)&&(Key!=VK_BACK)&&(Key!=VK_RETURN)&&(Key!=',')&&(Key!='.')) Key = 0;
	static WideChar temp;
	if ((Key==',') && (Edit1->Text[Edit1->Text.Length()]==Key)) Key = 0;
    if ((Key=='.') && (Edit1->Text[Edit1->Text.Length()]==',')) Key = 0;
	temp = Key;
}
//---------------------------------------------------------------------------
