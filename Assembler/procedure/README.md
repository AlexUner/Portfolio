<h2 align="center">Implement your own external procedure for combining text strings into one (string concatenation)</h2>

Write a program that works with strings.

Implement your own external procedure to combine text strings into one (string concatenation). The procedure must be able to concatenate up to four substring inputs.

The procedure must have 5 arguments: four arguments are the strings submitted for concatenation, the last argument is for 
The last argument is for the result of the procedure.

The procedure is to concatenate two to four substring arguments. If the procedure is supposed to concatenate fewer than four strings, e.g. two, it can pass 0 as the third and fourth arguments. The procedure checks the argument and, if its value is zero, ignores it.

The result of the procedure is placed in the fifth argument. In the EAX register the procedure should put the value of the joined string length.

Connect the procedure to the program and use it to display a formatted message.

<br>

<h2 align="center">Реализовать собственную внешнюю процедуру объединения текстовых строк в одну (конкатенация строк)</h2>

Написать программу, работающую со строками.

Реализовать собственную внешнюю процедуру объединения текстовых строк в одну (конкатенация строк). Процедура должна уметь объединять до четырёх подаваемых на вход подстрок.

Процедура должна иметь 5 аргументов: четыре аргумента – это подстроки, поданные для конкатенации, последний аргумент – для 
результата работы процедуры.

По условию процедура должна объединять от двух до четырех подстрок. Если предполагается объединение не четырех, а меньшего числа подстрок, например, двух, то в качестве третьего и четвертого аргументов возможна передача значения 0. Процедура проверяет аргумент, если его значение равно нулю, то игнорирует его.

Результат работы процедуры помещается в пятый аргумент. В регистр EAX процедура должна поместить значение длины объединенной строки.

Подключить процедуру к программе и использовать для вывода на экран форматированного сообщения.

<br>

<table><tr><td> 
  
  [main prog](procedure.asm) 
  </td>
  <td> 
  
  [procedure](str.inc) 
</td></tr></table>

| [main prog](procedure.asm)  | [procedure](str.inc)  |
