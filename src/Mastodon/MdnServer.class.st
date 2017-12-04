"
I represent a mastodon server (i.e. mastodon.social)
"
Class {
	#name : #MdnServer,
	#superclass : #Object,
	#traits : 'TMdnRequest',
	#classTraits : 'TMdnRequest classTrait',
	#instVars : [
		'url',
		'application'
	],
	#category : #Mastodon
}

{ #category : #accessing }
MdnServer class >> defaultApplicationName [
	^ 'PharoMastodon'
]

{ #category : #accessing }
MdnServer class >> defaultRedirectUri [
	^ 'urn:ietf:wg:oauth:2.0:oob'
]

{ #category : #'instance creation' }
MdnServer class >> new [
	self error: 'Use #newUrl:'
]

{ #category : #'instance creation' }
MdnServer class >> url: aStringOrUrl [
	^ self basicNew initializeUrl: aStringOrUrl
]

{ #category : #accessing }
MdnServer >> application [
	^ application ifNil: [ 
		application := self registerApplication: self class defaultApplicationName ]
]

{ #category : #initialization }
MdnServer >> initializeUrl: anUrl [
	url := anUrl asUrl.
	self initialize
]

{ #category : #api }
MdnServer >> loginUsername: aName password: aPassword [
	^ self  
		loginUsername: aName 
		password: aPassword
		scopes: MdnScope allScopes
]

{ #category : #api }
MdnServer >> loginUsername: aName password: aPassword scopes: aScopes [
	| app json |
	
	app := self application.
	json := self 
		post: self urlOAuth
		with: [ :req |
			req
				formAt: 'client_id' put: app clientId;
				formAt: 'client_secret' put: app clientSecret;
				formAt: 'grant_type' put: 'authorization_code';
				formAt: 'scopes' put: (self scopesToString: aScopes);
				formAt: 'username' put: aName;
				formAt: 'password' put: aPassword;
				formAt: 'grant_type' put: 'password' ].
	
	^ MdnLogin new 
		server: self;
		json: json;
		yourself
]

{ #category : #printing }
MdnServer >> printOn: stream [ 
	super printOn: stream.
	stream << '(' << self url asString << ')'
]

{ #category : #api }
MdnServer >> registerApplication: aName [
	^ self 
		registerApplication: aName 
		redirectUri: self class defaultRedirectUri
]

{ #category : #api }
MdnServer >> registerApplication: aName redirectUri: uriString [ 
	^ self 
		registerApplication: aName 
		redirectUri: uriString
		scopes: MdnScope allScopes
]

{ #category : #api }
MdnServer >> registerApplication: aName redirectUri: uriString scopes: aScopes [
	 ^ MdnApplication fromJson: (self 
			post: self urlApiApps 
			with: [ :request |
				request
					formAt: 'client_name' put: aName;
					formAt: 'redirect_uris' put: uriString;
					formAt: 'scopes' put: (self scopesToString: aScopes) ])
]

{ #category : #private }
MdnServer >> scopesToString: scopes [
	^ ' ' join: (scopes collect: #name)
]

{ #category : #accessing }
MdnServer >> url [ 
	^ url copy
]

{ #category : #accessing }
MdnServer >> urlApi [
	^ self url addPathSegments: #('api' 'v1')
]

{ #category : #accessing }
MdnServer >> urlApiAccounts [
	^ self urlApi addPathSegment: 'accounts'
]

{ #category : #accessing }
MdnServer >> urlApiApps [
	^ self urlApi addPathSegment: 'apps'
]

{ #category : #accessing }
MdnServer >> urlOAuth [
	^ self url addPathSegments: #('oauth' 'token')
]