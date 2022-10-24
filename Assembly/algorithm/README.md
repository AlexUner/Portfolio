<h2 align="center">Create a program that calculates the greatest common divisor of two given numbers</h2>

To calculate the greatest common divisor, implement and use the Euclidian algorithm.

A description of the Euclidian algorithm:

1. The greater of the two numbers is determined
2. The greater number is divided by the lesser number.
3. If the remainder of the division is 0, then the smaller number is the greater common divisor
4. If the remainder of the division is not 0, then the larger number is replaced by the smaller number, and the smaller number is replaced by the remainder of the division
5. Return to step 2

The input data is entered in the InputBox dialog using a plug-in custom library.

The result should be displayed in a message box, prompting you to repeat the calculation with the new numbers or to quit.

If one of the numeric values equals 0, a warning message should be displayed.

<br>

<h2 align="center">Создать программу, вычисляющую наибольший общий делитель для двух введённых чисел</h2>

Для вычисления наибольшего общего делителя реализовать и использовать алгоритм Евклида.

Описание алгоритма Евклида:

1. Определяется большее из двух чисел
2. Большее число делится на меньшее
3. Если остаток от деления равен 0, то меньшее число является наибольшим общим делителем
4. Если остаток от деления не равен 0, то большее число заменяется меньшим, а меньшее заменяется на остаток от деления
5. Возврат к пункту 2

Исходные данные вводятся в диалоговом окне ввода InputBox с помощью подключаемой пользовательской библиотеки.

Результат необходимо вывести в окне сообщения, предлагая повторить вычисления с новыми числами или завершить работу.

При вводе одного из числовых значений равных 0, вывести соответствующее сообщение с предупреждением.

<br>

| [main prog](math.asm)  | [procedure](str.inc)  | [macros](math.inc)  |
| --- | --- | --- |
