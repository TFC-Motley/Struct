# Struct

## Install
```
mops add Struct
```

## Usage
```motoko
import Struct "mo:Struct";

// Define the format of your packed binary record as an array of fields
//
// Where each field can be one of:
//   #n - Natural Number
//   #i - Signed Integer
//   #t - Text Literal
//   #s - Byte Sequence (Blob)
//   #p - Principal Identifier
//   #b - Boolean
//
// The length of all Nat, Int, Text, and Blob fields must be defined as a natural number.
//
// The length of all Boolean fields are set to 0. Boolean value is represented in the tag.
//
// The length of all Principal fields are set to 29 per the IC Interface Specification.
//
// ALL fields will have an additional single-byte tag prepended to their value. 
//
// The total length = Static Fields (Bool/Principal) + Dynamic Fields (Nat,Int,Text,Blob) + Number of fields

let schema: Schema = [#n()]
```