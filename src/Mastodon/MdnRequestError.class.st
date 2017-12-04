"
I'm an error to signal a problem when performing a request.
"
Class {
	#name : #MdnRequestError,
	#superclass : #MdnError,
	#instVars : [
		'code',
		'json'
	],
	#category : #Mastodon
}

{ #category : #private }
MdnRequestError class >> classFor: aString [
	^ self "allSubclasses 	
		detect: [ :each | each isError: aString ]
		ifNone: [ self defaultErrorClass ]"
]

{ #category : #private }
MdnRequestError class >> defaultErrorClass [
	^ MdnRequestError
]

{ #category : #testing }
MdnRequestError class >> isError: aString [ 
	^ false
]

{ #category : #signalling }
MdnRequestError class >> signalCode: aNumber json: jsonDictionary [
	^ (self classFor: (jsonDictionary at: 'error')) new
		code: aNumber;
		json: jsonDictionary;
		signal
]

{ #category : #signalling }
MdnRequestError class >> signalResponse: aResponse [
	^ self 
		signalCode: aResponse code 
		json: (STON fromString: aResponse contents)
]

{ #category : #accessing }
MdnRequestError >> code [
	^ code
]

{ #category : #accessing }
MdnRequestError >> code: anObject [
	code := anObject
]

{ #category : #accessing }
MdnRequestError >> errorCode [
	^ self json at: 'error'
]

{ #category : #accessing }
MdnRequestError >> errorDescription [
	^ self json at: 'error_description'
]

{ #category : #accessing }
MdnRequestError >> json [
	^ json
]

{ #category : #accessing }
MdnRequestError >> json: anObject [
	json := anObject
]

{ #category : #accessing }
MdnRequestError >> messageText [
	^ '{1}: {2} - {3}' format: { 
	self code.	
	self errorCode. 
	self errorDescription }
]