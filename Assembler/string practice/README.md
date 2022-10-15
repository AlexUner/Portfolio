<table>
<tr>
<td>

<h2 align="center">Create a programme that works with strings (ver.1)</h2>

The program searches for and replaces the two lowercase to uppercase characters. The text string and the two characters searched for are entered into the InputBox dialog using the plug-in user library. 

The program must check the entered values: the text string must not be empty, the characters to be searched for must not be empty and at the same time the number of characters entered (by definition) must not exceed one. Next, the characters to be searched for must be checked to see if they belong to the lowercase Latin letter set. 
If an input error is encountered, the program should offer to retry or to quit.

The resulting text string should be displayed in a message. The message screen with the result of the program should prompt to try to enter new data or to terminate.

</td>

<td>

<h2 align="center">Создать программу, работающую со строками (вер.1)</h2>

В программе происходит поиск и замена двух символов с нижнего регистра на верхний. Текстовая строка и оба искомых символа вводятся в диалоговом окне ввода InputBox с помощью подключаемой пользовательской библиотеки. 

Программа должна проверять введённые значения: текстовая строка не должна быть пустой, искомые символы не должны быть пустыми и одновременно количество введённых символов (по определению) не должно быть больше одного. Далее искомые символы должны проверяться на принадлежность набору строчных латинских букв. 
При возникновении ошибки ввода, программа должна предлагать повторить попытку ввода или завершить работу.

Полученная текстовая строка должна быть выведена на экран в сообщении. Экран сообщения с результатом работы программы должен предлагать попробовать ввести новые данные или завершить работу.

</td>

</tr>

<tr>

<td>

<h2 align="center">Create a programme that works with strings (ver.2)</h2>

The program should prompt the user to enter a text string. The text string is entered in the InputBox dialog box using the plug-in userdefined library.

The entered text string must not exceed 32 characters in length. If this rule is violated, the program should display an appropriate error window and offer to re-enter the string or quit.

The resulting text string must be analysed to see if it contains any capital characters. The position index of each uppercase character in the string must be stored in the program as a bitmask.

The program should then prompt you to enter a new text string. In the new text string the program checks the characters and their indexes using the available bitmask. If a character with the same index was capitalised in the first line, then in the new line the character at the position to which the index points must also be capitalised. The resulting text string must be displayed in a message. The message screen with the result of the program should prompt to try to enter a new second string to apply the saved bitmask to it.

</td>

<td>

<h2 align="center">Создать программу, работающую со строками (вер.2)</h2>

Программа должна предлагать пользователю ввести текстовую строку. Текстовая строка вводится в диалоговом окне ввода InputBox с помощью подключаемой пользовательской библиотеки. 

Введенная текстовая строка должна быть не более 32 символов длиной. При нарушении данного правила, программа должна показывать соответствующее окно с ошибкой и предлагать повторить ввод строки заново или завершить работу.

Полученная текстовая строка должна анализироваться на предмет наличия в ней заглавных символов. Индекс позиции каждого заглавного символа в строке должен запоминаться в программе в виде битовой маски.

Далее программа должна предлагать ввести новую текстовую строку. В новой текстовой строке программа проверяет символы и их индексы с помощью имеющейся битовой маски. Если в первой строке символ с таким же индексом был заглавным, то и в новой строке символ в позиции, на которую указывает индекс, должен быть заглавным. Полученная в результате текстовая строка должна быть выведена на экран в сообщении. Экран сообщения с результатом работы программы должен предлагать попробовать ввести новые вторую строку, чтобы применить к ней сохраненную битовую маску.

</td>
</tr>
</table>

<br>

[goto file](stringPractice.asm)
