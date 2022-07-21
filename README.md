# Ceaser-cipher
Background 
 A Caesar Cipher, also known as a shift cipher, is likely the simplest encryption technique in existence. This is a type of substitution cipher where each letter in the plaintext is shifted by some fixed number to transform that letter into another.  For example, if the plaintext were “here comes santa claus” and a Caesar Cipher was 
applied to this with a shift value of 3 then the resulting ciphertext would be “khuh frphv 
vdqwd fodxv”. 
Your program MUST use a function to perform the Caesar Cipher on the plaintext. 
 
• caesar function received its arguments (plaintext and shift value at a 
minimum) from the stack. 
 
• program read user input through stdin. 
o Prompt the user for each input 
 Ex. “Please enter the plaintext: ” 
 Ex. “Please enter the shift value: ” 
 
Procedure: 

Traverse the given text one character at a time .
For each character, transform the given character as per the rule, depending on whether we’re encrypting or decrypting the text.
Return the new string generated.

 we can use the same function to decrypt, instead, we’ll modify the shift value such that shift = 26-shift
 
 
