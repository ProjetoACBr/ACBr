unit OpenSSLExt;

{==============================================================================|
| Project : Ararat Synapse                                       | 003.004.001 |
|==============================================================================|
| Content: SSL support by OpenSSL                                              |
|==============================================================================|
| Copyright (c)1999-2005, Lukas Gebauer                                        |
| All rights reserved.                                                         |
|                                                                              |
| Redistribution and use in source and binary forms, with or without           |
| modification, are permitted provided that the following conditions are met:  |
|                                                                              |
| Redistributions of source code must retain the above copyright notice, this  |
| list of conditions and the following disclaimer.                             |
|                                                                              |
| Redistributions in binary form must reproduce the above copyright notice,    |
| this list of conditions and the following disclaimer in the documentation    |
| and/or other materials provided with the distribution.                       |
|                                                                              |
| Neither the name of Lukas Gebauer nor the names of its contributors may      |
| be used to endorse or promote products derived from this software without    |
| specific prior written permission.                                           |
|                                                                              |
| THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  |
| AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    |
| IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   |
| ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR  |
| ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL       |
| DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR   |
| SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER   |
| CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT           |
| LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY    |
| OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH  |
| DAMAGE.                                                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Lukas Gebauer (Czech Republic).|
| Portions created by Lukas Gebauer are Copyright (c)2002-2005.                |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| FreePascal basic cleanup (original worked too): Ales Katona                  |
| WARNING: due to reliance on some units, I have removed the ThreadLocks init  |
|          if need be, it should be re-added, or handled by the                |
|           OS threading init somehow                                          |
|                                                                              |
| 2010 - Felipe Monteiro de Carvalho - Added RAND functios                     |
|==============================================================================|
|  2010-08-24 add fuctions to hash strings based on rsa key PEM format         |
|             change some type declarationc on x509 type                       |
|             work is not complete.                                            |
|             Work made by Alberto Brito based on unit from Marco Ferrante     |
|==============================================================================|
| 2020/01 - Daniel Sim�es de Almeida                                           |
|         - Reviewed to work with OpenSSL 1.1.1                                |
|         - A lot of methods added (TODO: datail)                              |
|         - Delphi VCL/FMX, Windows/Linux compatibility                        |
|==============================================================================|
| History: see HISTORY.HTM from distribution package                           |
|          (Found at URL: http://www.ararat.cz/synapse/)                       |
|==============================================================================}

{
Special thanks to Gregor Ibic <gregor.ibic@intelicom.si>
 (Intelicom d.o.o., http://www.intelicom.si)
 for good inspiration about begin with SSL programming.
}
{$I ACBr.inc}

{$IfDef FPC}
{$Packrecords C}
{$EndIf}

{:@abstract(OpenSSL support)

This unit is Pascal interface to OpenSSL library (used by @link(ssl_openssl) unit).
OpenSSL is loaded dynamicly on-demand. If this library is not found in system,
requested OpenSSL function just return errorcode.
}

interface

uses
  {$IFDEF OS2}
   Sockets,
  {$ENDIF OS2}
  {$IfDef FPC}
   DynLibs, cTypes,
  {$Else}
   Types,
  {$EndIf}
  {$IfDef MSWINDOWS}
   Windows,
  {$EndIf}
  SyncObjs, SysUtils;

var
  {$IFNDEF MSWINDOWS}
   {$IFDEF DARWIN}
    DLLSSLNames: array[1..1] of string = ('libssl.dylib');
    DLLUtilNames: array[1..1] of string = ('libcrypto.dylib');
   {$ELSE}
    {$IFDEF OS2}
     {$IFDEF OS2GCC}
      DLLSSLNames: array[1..2] of string = ('kssl10.dll','kssl.dll');
      DLLUtilNames: array[1..2] of string = ('kcrypt10.dll','kcrypto.dll');
     {$ELSE OS2GCC}
      DLLSSLNames: array[1..2] of string = ('emssl10.dll','ssl.dll');
      DLLUtilNames: array[1..2] of string = ('emcrpt10.dll','crypto.dll');
     {$ENDIF OS2GCC}
    {$ELSE OS2}
     DLLSSLNames: array[1..17] of string = ('libssl.so',  // this file only exist in dev-packages that are not installed by default on most distributions
                                            'libssl.so.3',
                                            'libssl.so.1.1', 'libssl.so.10', 'libssl.so.1.1.1', 'libssl.so.1.1.0',
                                            'libssl.so.1.0.2', 'libssl.so.1.0.1', 'libssl.so.1.0.0',
                                            'libssl.so.0.9.8', 'libssl.so.0.9.7', 'libssl.so.0.9.6', 'libssl.so.0.9.5',
                                            'libssl.so.0.9.4', 'libssl.so.0.9.3', 'libssl.so.0.9.2', 'libssl.so.0.9.1'
                                           );
     DLLUtilNames: array[1..17] of string = ('libcrypto.so', // this file only exist in dev-packages that are not installed by default on most distributions
                                             'libcrypto.so.3',
                                             'libcrypto.so.1.1', 'libcrypto.so.10', 'libcrypto.so.1.1.1', 'libcrypto.so.1.1.0',
                                             'libcrypto.so.1.0.2', 'libcrypto.so.1.0.1', 'libcrypto.so.1.0.0',
                                             'libcrypto.so.0.9.8', 'libcrypto.so.0.9.7', 'libcrypto.so.0.9.6', 'libcrypto.so.0.9.5',
                                             'libcrypto.so.0.9.4', 'libcrypto.so.0.9.3', 'libcrypto.so.0.9.2', 'libcrypto.so.0.9.1'
                                            );
    {$ENDIF OS2}
   {$ENDIF}
  {$ELSE}
   DLLSSLNames: array[1..5] of string = ({$IfDef WIN64}
                                          'libssl-3-x64.dll','libssl-1_1-x64.dll'
                                         {$Else}
                                          'libssl-3.dll','libssl-1_1.dll'
                                         {$EndIf},
                                         'ssleay32.dll', 'libssl32.dll', 'libssl.dll');
   DLLUtilNames: array[1..5] of string = ({$IfDef WIN64}
                                           'libcrypto-3-x64.dll','libcrypto-1_1-x64.dll'
                                          {$Else}
                                           'libcrypto-3.dll','libcrypto-1_1.dll'
                                          {$EndIf},
                                          'libeay32.dll', 'libcrypto.dll', 'libeay.dll');
  {$ENDIF}


{$IfNDef FPC}
 {$IfDef CPUX64}
  {$Define CPU64}
 {$EndIf}
 // Converting FPC CTypes to Delphi
 type
   {$If not DECLARED(DWord)}
    DWord = LongWord;
   {$IfEnd}
   {$If not DECLARED(TBytes)}
    TBytes = array of Byte;
   {$IfEnd}
   cint = LongInt;
   pcint = ^cint;
   cuint = LongWord;
   pcuint = ^cuint;
   PDWord = ^DWord;
   culong = Cardinal;
   clong = {$IfDef CPU64}Int64{$Else}LongInt{$EndIf};
   cdouble = Double;
   PtrUInt = {$IfDef CPU64}Int64{QWord}{$Else}DWord{$ENDIF};
   csize_t = PtrUInt;
   pcsize_t  = ^PtrUInt;
   TLibHandle = THandle;
   cuint8 = Byte;
   cuchar = cuint8;
   pcuchar = ^cuchar;

  // NEXTGEN legacy compatibility
  {$IfDef NEXTGEN}
    AnsiString = RawByteString;
    AnsiChar = UTF8Char;
    PAnsiChar = PUTF8Char;
    PPAnsiChar = ^PUTF8Char;
  {$EndIf}
 const
    LineEnding = #13#10;
{$EndIf}

const
  // EVP.h Constants

  EVP_MAX_MD_SIZE       = 64; //* longest known is SHA512 */
  EVP_MAX_KEY_LENGTH    = 32;
  EVP_MAX_IV_LENGTH     = 16;
  EVP_MAX_BLOCK_LENGTH  = 32;

  SHA_DIGEST_LENGTH     = 20;
  EVP_PKEY_HMAC         = 855;  // Tz HMAC

  EVP_PKEY_RSA = 6;
  EVP_PKEY_ALG_CTRL = 4096;
  EVP_PKEY_CTRL_RSA_PADDING  = (EVP_PKEY_ALG_CTRL + 1);
  EVP_PKEY_CTRL_RSA_PSS_SALTLEN = (EVP_PKEY_ALG_CTRL + 2);
  EVP_PKEY_CTRL_RSA_KEYGEN_BITS = (EVP_PKEY_ALG_CTRL + 3);
  EVP_PKEY_CTRL_RSA_KEYGEN_PUBEXP = (EVP_PKEY_ALG_CTRL + 4);
  EVP_PKEY_CTRL_RSA_MGF1_MD = (EVP_PKEY_ALG_CTRL + 5);
  EVP_PKEY_CTRL_GET_RSA_PADDING = (EVP_PKEY_ALG_CTRL + 6);
  EVP_PKEY_CTRL_GET_RSA_PSS_SALTLEN = (EVP_PKEY_ALG_CTRL + 7);
  EVP_PKEY_CTRL_GET_RSA_MGF1_MD = (EVP_PKEY_ALG_CTRL + 8);
  EVP_PKEY_CTRL_RSA_OAEP_MD = (EVP_PKEY_ALG_CTRL + 9);
  EVP_PKEY_CTRL_RSA_OAEP_LABEL = (EVP_PKEY_ALG_CTRL + 10);
  EVP_PKEY_CTRL_GET_RSA_OAEP_MD = (EVP_PKEY_ALG_CTRL + 11);
  EVP_PKEY_CTRL_GET_RSA_OAEP_LABEL = (EVP_PKEY_ALG_CTRL + 12);
  EVP_PKEY_CTRL_RSA_KEYGEN_PRIMES = (EVP_PKEY_ALG_CTRL + 13);

  EVP_PKEY_OP_UNDEFINED = 0;
  EVP_PKEY_OP_PARAMGEN = 2;       // (1<<1)
  EVP_PKEY_OP_KEYGEN = 4;         // (1<<2)
  EVP_PKEY_OP_SIGN = 8;           // (1<<3)
  EVP_PKEY_OP_VERIFY = 16;        // (1<<4)
  EVP_PKEY_OP_VERIFYRECOVER = 32; // (1<<5)
  EVP_PKEY_OP_SIGNCTX = 64;       // (1<<6)
  EVP_PKEY_OP_VERIFYCTX = 128;    // (1<<7)
  EVP_PKEY_OP_ENCRYPT = 256;      // (1<<8)
  EVP_PKEY_OP_DECRYPT = 512;      // (1<<9)
  EVP_PKEY_OP_DERIVE = 1024;      // (1<<10)

  EVP_PKEY_OP_TYPE_CRYPT = (EVP_PKEY_OP_ENCRYPT or EVP_PKEY_OP_DECRYPT);
  EVP_PKEY_OP_TYPE_SIG = (EVP_PKEY_OP_SIGN or EVP_PKEY_OP_VERIFY or
    EVP_PKEY_OP_VERIFYRECOVER or EVP_PKEY_OP_SIGNCTX or EVP_PKEY_OP_VERIFYCTX);

type
  SslPtr = Pointer;
  PSslPtr = ^SslPtr;
  PSSL_CTX = SslPtr;
  PSSL = SslPtr;
  PSTACK = SslPtr;
  PSSL_METHOD = SslPtr;
  PEVP_MD = SslPtr;
  PBIO_METHOD = SslPtr;
  PBIO = SslPtr;
  PASN1_UTCTIME = SslPtr;
  PASN1_INTEGER = SSlPtr;

  pRSA = ^RSA;
  PDH = pointer;
  PSTACK_OFX509 = pointer;

  X509_NAME = record
    entries: pointer;
    modified: integer;
    bytes: pointer;
    hash: cardinal;
  end;
  PX509_NAME = ^X509_NAME;
  PDN = ^X509_NAME;

  ASN1_STRING = record
    length: integer;
    asn1_type: integer;
    data: pointer;
    flags: longint;
  end;
  PASN1_STRING = ^ASN1_STRING;
  PASN1_TIME = PASN1_STRING;

  X509_VAL = record
    notBefore: PASN1_TIME;
    notAfter: PASN1_TIME;
  end;
  PX509_VAL = ^X509_VAL;

  X509_CINF = record
    version: pointer;
    serialNumber: pointer;
    signature: pointer;
    issuer: pointer;
    validity: PX509_VAL;
    subject: pointer;
    key: pointer;
    issuerUID: pointer;
    subjectUID: pointer;
    extensions: pointer;
  end;
  PX509_CINF = ^X509_CINF;

  CRYPTO_EX_DATA = record
    sk: pointer;
    dummy: integer;
    end;

  X509 = record
    cert_info: PX509_CINF;
    sig_alg: pointer;  // ^X509_ALGOR
    signature: pointer;  // ^ASN1_BIT_STRING
    valid: integer;
    references: integer;
    name: PAnsiChar;
    ex_data: CRYPTO_EX_DATA;
    ex_pathlen: integer;
    ex_flags: integer;
    ex_kusage: integer;
    ex_xkusage: integer;
    ex_nscert: integer;
    skid: pointer;  // ^ASN1_OCTET_STRING
    akid: pointer;  // ?
    sha1_hash: array [0..SHA_DIGEST_LENGTH-1] of char;
    aux: pointer;  // ^X509_CERT_AUX
  end;
  pX509 = ^X509;
  PPX509 = ^PX509;

  pX509_EXTENSION = ^X509_EXTENSION;
  X509_EXTENSION = record
    obj: pointer;
    critical: Smallint;
    netscape_hack: Smallint;
    value: pASN1_STRING;
    method: pointer;	// struct v3_ext_method *: V3 method to use
    ext_val: pointer;	// extension value
  end;

  X509_REQ_INFO = record
    enc: Pointer;
    version: Pointer;
    subject: Pointer;
    pubkey: Pointer;
    attributes: Pointer;
  end;
  PX509_REQ_INFO = ^X509_REQ_INFO;

  X509_REQ = record
    req_info: PX509_REQ_INFO;
    sig_alg: Pointer;
    signature: Pointer;
    references: Integer;
    lock: Pointer;
    distinguishing_id: Pointer;
    libctx: Pointer;
    propq: Pointer;
  end;
  PX509_REQ = ^X509_REQ;

  DSA = record
    pad: integer;
    version: integer;
    write_params: integer;
    p: pointer;
    q: pointer;
    g: pointer;
    pub_key: pointer;
    priv_key: pointer;
    kinv: pointer;
    r: pointer;
    flags: integer;
    method_mont_p: PAnsiChar;
    references: integer;
    ex_data: record
      sk: pointer;
      dummy: integer;
    end;
    meth: pointer;
  end;
  pDSA = ^DSA;

  EVP_PKEY_PKEY = record
    case integer of
      0: (ptr: PAnsiChar);
      1: (rsa: pRSA);
      2: (dsa: pDSA);
      3: (dh: pDH);
  end;

  EVP_PKEY = record
    ktype: integer;
    save_type: integer;
    references: integer;
    pkey: EVP_PKEY_PKEY;
    save_parameters: integer;
    attributes: PSTACK_OFX509;
  end;
  PEVP_PKEY = ^EVP_PKEY;
  PPEVP_PKEY = ^PEVP_PKEY;

  PPRSA = ^PRSA;
  PASN1_cInt = SslPtr;
  PPasswdCb = SslPtr;
  PCallbackCb = SslPtr;

  PX509_STORE = SslPtr;
  PX509_STORE_CTX = SslPtr;
  TSSLCTXVerifyCallback = function (ok : cInt; ctx : PX509_STORE_CTX) : Cint; cdecl;

  PFunction = procedure;
  DES_cblock = array[0..7] of Byte;
  PDES_cblock = ^DES_cblock;
  des_ks_struct = packed record
    ks: DES_cblock;
    weak_key: cInt;
  end;
  des_key_schedule = array[1..16] of des_ks_struct;

  MD2_CTX = record
    num: integer;
    data: array [0..15] of byte;
    cksm: array [0..15] of cardinal;
    state: array [0..15] of cardinal;
  end;
  MD4_CTX = record
    A, B, C, D: cardinal;
    Nl, Nh: cardinal;
    data: array [0..15] of cardinal;
    num: integer;
  end;
  MD5_CTX = record
    A, B, C, D: cardinal;
    Nl, Nh: cardinal;
    data: array [0..15] of cardinal;
    num: integer;
  end;
  RIPEMD160_CTX = record
    A, B, C, D, E: cardinal;
    Nl, Nh: cardinal;
    data: array [0..15] of cardinal;
    num: integer;
  end;
  SHA_CTX = record
    h0, h1, h2, h3, h4: cardinal;
    Nl, Nh: cardinal;
    data: array [0..16] of cardinal;
    num: integer;
  end;
  MDC2_CTX = record
    num: integer;
    data: array [0..7] of byte;
    h, hh: des_cblock;
    pad_type: integer;
  end;

  // Rand
  RAND_METHOD = record
  end;
  PRAND_METHOD = ^RAND_METHOD;

  // RSA
  PENGINE = Pointer;
  PBIGNUM = Pointer;
  PBN_GENCB = Pointer;
  PBN_MONT_CTX = Pointer;
  PBN_BLINDING = Pointer;
  PBN_CTX = Pointer;
  PPByte = ^PByte;

  Trsa_pub_enc = function(flen: cint;
                 const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_pub_dec = function(flen: cint;
                 const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_priv_enc = function(flen: cint;
                 const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_priv_dec = function(flen: cint;
                 const from_, to_: PByte; arsa: PRSA; padding: cint): cint;
  Trsa_mod_exp = function(r0: PBIGNUM; const l: PBIGNUM; arsa: PRSA; ctx: PBN_CTX): cint;
  Tbn_mod_exp = function(r: PBIGNUM; const a, p, m: PBIGNUM; arsa: PRSA;
                 ctx: PBN_CTX; m_ctx: PBN_MONT_CTX): cint;
  Tinit = function(arsa: PRSA): cint;
  Tfinish = function(arsa: PRSA): cint;
  Trsa_sign = function(type_: cint; const m: PByte; m_length: cuint;
                 sigret: PByte; siglen: pcuint; arsa: PRSA): cint;
  Trsa_verify = function(dtype: cint;
                 const m: PByte; m_length: cuint;
                 const sigbuf: PByte; siglen: cuint; arsa: PRSA): cint;
  Trsa_keygen = function(arsa: PRSA; bits: cint; e: PBIGNUM; cb: PBN_GENCB): cint;

  Tsk_pop_free_func = procedure (p : Pointer);

  RSA_METHOD = record
    name: PAnsiChar;
    rsa_pub_enc: Trsa_pub_enc;
    rsa_pub_dec: Trsa_pub_dec;
    rsa_priv_enc: Trsa_priv_enc;
    rsa_priv_dec: Trsa_priv_dec;
    rsa_mod_exp: Trsa_mod_exp; { Can be null }
    bn_mod_exp: Tbn_mod_exp; { Can be null }
    init: Tinit; { called at new }
    finish: Tfinish; { called at free }
    flags: cint; { RSA_METHOD_FLAG_* things }
    app_data: PAnsiChar; { may be needed! }
  { New sign and verify functions: some libraries don't allow arbitrary data
   * to be signed/verified: this allows them to be used. Note: for this to work
   * the RSA_public_decrypt() and RSA_private_encrypt() should *NOT* be used
   * RSA_sign(), RSA_verify() should be used instead. Note: for backwards
   * compatibility this functionality is only enabled if the RSA_FLAG_SIGN_VER
   * option is set in 'flags'.
   }
    rsa_sign: Trsa_sign;
    rsa_verify: Trsa_verify;
  { If this callback is NULL, the builtin software RSA key-gen will be used. This
   * is for behavioural compatibility whilst the code gets rewired, but one day
   * it would be nice to assume there are no such things as "builtin software"
   * implementations. }
    rsa_keygen: Trsa_keygen;
  end;
  PRSA_METHOD = ^RSA_METHOD;

  RSA = record
    // The first parameter is used to pickup errors where
    // this is passed instead of aEVP_PKEY, it is set to 0
    pad: integer;
    version: integer;
    meth: pRSA_METHOD;
    n: pBIGNUM;
    e: pBIGNUM;
    d: pBIGNUM;
    p: pBIGNUM;
    q: pBIGNUM;
    dmp1: pBIGNUM;
    dmq1: pBIGNUM;
    iqmp: pBIGNUM;
    // be careful using this if the RSA structure is shared
    ex_data: CRYPTO_EX_DATA;
    references: integer;
    flags: integer;
    // Used to cache montgomery values
    _method_mod_n: pBN_MONT_CTX;
    _method_mod_p: pBN_MONT_CTX;
    _method_mod_q: pBN_MONT_CTX;
    // all BIGNUM values are actually in the following data, if it is not
    // NULL
    bignum_data: ^byte;
    blinding: PBN_BLINDING;
  end;

  // EVP

  EVP_MD_CTX = record
    digest: pEVP_MD;
    case integer of
      0: (base: array [0..3] of byte);
      1: (md2: MD2_CTX);
      8: (md4: MD4_CTX);
      2: (md5: MD5_CTX);
      16: (ripemd160: RIPEMD160_CTX);
      4: (sha: SHA_CTX);
      32: (mdc2: MDC2_CTX);
    end;
  PEVP_MD_CTX = ^EVP_MD_CTX;

  EVP_PKEY_CTX = record
  end;
  PEVP_PKEY_CTX = ^EVP_PKEY_CTX;
  PPEVP_PKEY_CTX = ^PEVP_PKEY_CTX;

  PEVP_CIPHER_CTX = ^EVP_CIPHER_CTX;

  PASN1_TYPE = Pointer;

  EVP_CIPHER_INIT_FUNC = function(ctx: PEVP_CIPHER_CTX; const key, iv: PByte; enc: cint): cint; cdecl;
  EVP_CIPHER_DO_CIPHER_FUNC = function(ctx: PEVP_CIPHER_CTX; out_data: PByte; const in_data: PByte; inl: csize_t): cint; cdecl;
  EVP_CIPHER_CLEANUP_FUNC = function(ctx: PEVP_CIPHER_CTX): cint; cdecl;
  EVP_CIPHER_SET_ASN1_PARAMETERS_FUNC = function(ctx: PEVP_CIPHER_CTX; asn1_type: PASN1_TYPE): cint; cdecl;
  EVP_CIPHER_GET_ASN1_PARAMETERS_FUNC = function(ctx: PEVP_CIPHER_CTX; asn1_type: PASN1_TYPE): cint; cdecl;
  EVP_CIPHER_CTRL_FUNC = function(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint; cdecl;

  EVP_CIPHER = record  // Updated with EVP.h from OpenSSL 1.0.0
    nid: cint;
    block_size: cint;
    key_len: cint;  //* Default value for variable length ciphers */
    iv_len: cint;
    flags: culong; //* Various flags */
    init: EVP_CIPHER_INIT_FUNC; //* init key */
    do_cipher: EVP_CIPHER_DO_CIPHER_FUNC;//* encrypt/decrypt data */
    cleanup: EVP_CIPHER_CLEANUP_FUNC; //* cleanup ctx */
    ctx_size: cint;   //* how big ctx->cipher_data needs to be */
    set_asn1_parameters: EVP_CIPHER_SET_ASN1_PARAMETERS_FUNC; //* Populate a ASN1_TYPE with parameters */
    get_asn1_parameters: EVP_CIPHER_GET_ASN1_PARAMETERS_FUNC; //* Get parameters from a ASN1_TYPE */
    ctrl: EVP_CIPHER_CTRL_FUNC; //* Miscellaneous operations */
    app_data: Pointer;  //* Application data */
  end;
  PEVP_CIPHER = ^EVP_CIPHER;

  EVP_CIPHER_CTX = record // Updated with EVP.h from OpenSSL 1.0.0
    cipher: PEVP_CIPHER;
    engine: PENGINE;  //* functional reference if 'cipher' is ENGINE-provided */
    encrypt: cint;    //* encrypt or decrypt */
    buf_len: cint;    //* number we have left */

    oiv: array[0..EVP_MAX_IV_LENGTH-1] of Byte;  //* original iv */
    iv: array[0..EVP_MAX_IV_LENGTH-1] of Byte; //* working iv */
    buf: array[0..EVP_MAX_IV_LENGTH-1] of Byte; //* saved partial block */
    num: cint;        //* used by cfb/ofb mode */

    app_data: Pointer;   //* application stuff */
    key_len: cint;    //* May change for variable length cipher */
    flags: culong;  //* Various flags */
    cipher_data: Pointer; //* per EVP data */
    final_used: cint;
    block_mask: cint;
    final: array[0..EVP_MAX_BLOCK_LENGTH-1] of Byte; //* possible final block */
    final2: array[0..$1FFF] of Byte; // Extra storage space, otherwise an access violation
                                     // in the OpenSSL library will occur
  end;

  // PEM
  Ppem_password_cb = Pointer;

  // PKCS7
  PPKCS7  = ^PKCS7;
  PPKCS7_DIGEST  = ^PKCS7_DIGEST;
  PPKCS7_ENC_CONTENT  = ^PKCS7_ENC_CONTENT;
  PPKCS7_ENCRYPT  = ^TPKCS7_ENCRYPT;
  PPKCS7_ENVELOPE  = ^PKCS7_ENVELOPE;
  PPKCS7_ISSUER_AND_SERIAL  = ^PKCS7_ISSUER_AND_SERIAL;
  PPKCS7_RECIP_INFO  = ^PKCS7_RECIP_INFO;
  PPKCS7_SIGN_ENVELOPE  = ^PKCS7_SIGN_ENVELOPE;
  PPKCS7_SIGNED  = ^PKCS7_SIGNED;
  PPKCS7_SIGNER_INFO  = ^PKCS7_SIGNER_INFO;
  Pstack_st_X509  = Pointer;
  Pstack_st_X509_ALGOR  = Pointer;
  Pstack_st_X509_ATTRIBUTE  = Pointer;
  ppkcs7_st = ^pkcs7_st;

  pkcs7_issuer_and_serial_st = record
    issuer : ^X509_NAME;
    serial : PASN1_INTEGER;
  end;
  PKCS7_ISSUER_AND_SERIAL = pkcs7_issuer_and_serial_st;

  pkcs7_signer_info_st = record
    version : PASN1_INTEGER;
    issuer_and_serial : PPKCS7_ISSUER_AND_SERIAL;
    digest_alg : pointer;
    auth_attr : pointer;
    digest_enc_alg : pointer;
    enc_digest : pointer;
    unauth_attr : pointer;
    pkey : ^EVP_PKEY;
  end;
  PKCS7_SIGNER_INFO = pkcs7_signer_info_st;

  stack_st_PKCS7_SIGNER_INFO = record
    stack : Pointer;
  end;

  pkcs7_recip_info_st = record
    version : PASN1_INTEGER;
    issuer_and_serial : PPKCS7_ISSUER_AND_SERIAL;
    key_enc_algor : Pointer;
    enc_key : Pointer;
    cert : PX509;
  end;
  PKCS7_RECIP_INFO = pkcs7_recip_info_st;

  stack_st_PKCS7_RECIP_INFO = record
    stack : Pointer;
  end;

  pkcs7_signed_st = record
    version : PASN1_INTEGER;
    md_algs : Pointer;
    cert : pointer;
    crl : pointer;
    signer_info : pointer;
    contents : Pointer;
  end;
  PKCS7_SIGNED = pkcs7_signed_st;
  (* Const before type ignored *)

  pkcs7_enc_content_st = record
    content_type : Pointer;
    algorithm : Pointer;
    enc_data : Pointer;
    cipher : PEVP_CIPHER;
  end;
  PKCS7_ENC_CONTENT = pkcs7_enc_content_st;

  pkcs7_enveloped_st = record
    version : PASN1_INTEGER;
    recipientinfo : ^stack_st_PKCS7_RECIP_INFO;
    enc_data : ^PKCS7_ENC_CONTENT;
  end;
  PKCS7_ENVELOPE = pkcs7_enveloped_st;

  pkcs7_signedandenveloped_st = record
    version : PASN1_INTEGER;
    md_algs : Pstack_st_X509_ALGOR;
    cert : Pstack_st_X509;
    crl : Pointer;
    signer_info : pointer;
    enc_data : PPKCS7_ENC_CONTENT;
    recipientinfo : ^stack_st_PKCS7_RECIP_INFO;
  end;
  PKCS7_SIGN_ENVELOPE = pkcs7_signedandenveloped_st;

  pkcs7_digest_st = record
    version : PASN1_INTEGER;
    md : POinter;
    contents : ppkcs7_st;
    digest : Pointer;
  end;
  PKCS7_DIGEST = pkcs7_digest_st;

  pkcs7_encrypted_st = record
    version : PASN1_INTEGER;
    enc_data : ^PKCS7_ENC_CONTENT;
  end;
  TPKCS7_ENCRYPT = pkcs7_encrypted_st;

  pkcs7_st = record
    asn1 : ^byte;
    length : longint;
    state : longint;
    detached : longint;
    _type : Pointer;
    d : record
      case longint of
        0 : ( ptr : PAnsiChar );
        1 : ( data : Pointer);
        2 : ( sign : PPKCS7_SIGNED );
        3 : ( enveloped : ^PKCS7_ENVELOPE );
        4 : ( signed_and_enveloped : ^PKCS7_SIGN_ENVELOPE );
        5 : ( digest : ^PKCS7_DIGEST );
        6 : ( encrypted : ^TPKCS7_ENCRYPT );
        7 : ( other : PASN1_TYPE );
      end;
  end;
  pkcs7 = pkcs7_st;

  stack_st_PKCS7 = record
    stack : Pointer;
  end;
  PPPKCS7_ISSUER_AND_SERIAL = ^PPKCS7_ISSUER_AND_SERIAL;

const
  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_WANT_X509_LOOKUP = 4;
  SSL_ERROR_SYSCALL = 5; //look at error stack/return value/errno
  SSL_ERROR_ZERO_RETURN = 6;
  SSL_ERROR_WANT_CONNECT = 7;
  SSL_ERROR_WANT_ACCEPT = 8;
  SSL_ERROR_WANT_CHANNEL_ID_LOOKUP = 9;
  SSL_ERROR_PENDING_SESSION = 11;

  SSL_CTRL_NEED_TMP_RSA = 1;
  SSL_CTRL_SET_TMP_RSA = 2;
  SSL_CTRL_SET_TMP_DH = 3;
  SSL_CTRL_SET_TMP_ECDH = 4;
  SSL_CTRL_SET_TMP_RSA_CB = 5;
  SSL_CTRL_SET_TMP_DH_CB = 6;
  SSL_CTRL_SET_TMP_ECDH_CB = 7;
  SSL_CTRL_GET_SESSION_REUSED = 8;
  SSL_CTRL_GET_CLIENT_CERT_REQUEST = 9;
  SSL_CTRL_GET_NUM_RENEGOTIATIONS = 10;
  SSL_CTRL_CLEAR_NUM_RENEGOTIATIONS = 11;
  SSL_CTRL_GET_TOTAL_RENEGOTIATIONS = 12;
  SSL_CTRL_GET_FLAGS = 13;
  SSL_CTRL_EXTRA_CHAIN_CERT = 14;
  SSL_CTRL_SET_MSG_CALLBACK = 15;
  SSL_CTRL_SET_MSG_CALLBACK_ARG = 16;
  SSL_CTRL_SET_MTU = 17;
  SSL_CTRL_SESS_NUMBER = 20;
  SSL_CTRL_SESS_CONNECT = 21;
  SSL_CTRL_SESS_CONNECT_GOOD = 22;
  SSL_CTRL_SESS_CONNECT_RENEGOTIATE = 23;
  SSL_CTRL_SESS_ACCEPT = 24;
  SSL_CTRL_SESS_ACCEPT_GOOD = 25;
  SSL_CTRL_SESS_ACCEPT_RENEGOTIATE = 26;
  SSL_CTRL_SESS_HIT = 27;
  SSL_CTRL_SESS_CB_HIT = 28;
  SSL_CTRL_SESS_MISSES = 29;
  SSL_CTRL_SESS_TIMEOUTS = 30;
  SSL_CTRL_SESS_CACHE_FULL = 31;
  SSL_CTRL_OPTIONS = 32;
  SSL_CTRL_MODE = 33;
  SSL_CTRL_GET_READ_AHEAD = 40;
  SSL_CTRL_SET_READ_AHEAD = 41;
  SSL_CTRL_SET_SESS_CACHE_SIZE = 42;
  SSL_CTRL_GET_SESS_CACHE_SIZE = 43;
  SSL_CTRL_SET_SESS_CACHE_MODE = 44;
  SSL_CTRL_GET_SESS_CACHE_MODE = 45;
  SSL_CTRL_GET_MAX_CERT_LIST = 50;
  SSL_CTRL_SET_MAX_CERT_LIST = 51;
  SSL_CTRL_SET_MAX_SEND_FRAGMENT              = 52;
  SSL_CTRL_SET_TLSEXT_SERVERNAME_CB           = 53;
  SSL_CTRL_SET_TLSEXT_SERVERNAME_ARG          = 54;
  SSL_CTRL_SET_TLSEXT_HOSTNAME                = 55;
  SSL_CTRL_SET_TLSEXT_DEBUG_CB                = 56;
  SSL_CTRL_SET_TLSEXT_DEBUG_ARG               = 57;
  SSL_CTRL_GET_TLSEXT_TICKET_KEYS             = 58;
  SSL_CTRL_SET_TLSEXT_TICKET_KEYS             = 59;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT        = 60;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT_CB     = 61;
  SSL_CTRL_SET_TLSEXT_OPAQUE_PRF_INPUT_CB_ARG = 62;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_CB           = 63;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_CB_ARG       = 64;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_TYPE         = 65;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_EXTS         = 66;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_EXTS         = 67;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_IDS          = 68;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_IDS          = 69;
  SSL_CTRL_GET_TLSEXT_STATUS_REQ_OCSP_RESP    = 70;
  SSL_CTRL_SET_TLSEXT_STATUS_REQ_OCSP_RESP    = 71;
  SSL_CTRL_SET_TLSEXT_TICKET_KEY_CB           = 72;
  SSL_CTRL_SET_TLS_EXT_SRP_USERNAME_CB        = 75;
  SSL_CTRL_SET_SRP_VERIFY_PARAM_CB            = 76;
  SSL_CTRL_SET_SRP_GIVE_CLIENT_PWD_CB         = 77;
  SSL_CTRL_SET_SRP_ARG                        = 78;
  SSL_CTRL_SET_TLS_EXT_SRP_USERNAME           = 79;
  SSL_CTRL_SET_TLS_EXT_SRP_STRENGTH           = 80;
  SSL_CTRL_SET_TLS_EXT_SRP_PASSWORD           = 81;
  SSL_CTRL_GET_EXTRA_CHAIN_CERTS              = 82;
  SSL_CTRL_CLEAR_EXTRA_CHAIN_CERTS            = 83;
  SSL_CTRL_TLS_EXT_SEND_HEARTBEAT             = 85;
  SSL_CTRL_GET_TLS_EXT_HEARTBEAT_PENDING      = 86;
  SSL_CTRL_SET_TLS_EXT_HEARTBEAT_NO_REQUESTS  = 87;
  SSL_CTRL_CHAIN                              = 88;
  SSL_CTRL_CHAIN_CERT                         = 89;
  SSL_CTRL_GET_CURVES                         = 90;
  SSL_CTRL_SET_CURVES                         = 91;
  SSL_CTRL_SET_CURVES_LIST                    = 92;
  SSL_CTRL_GET_SHARED_CURVE                   = 93;
  SSL_CTRL_SET_ECDH_AUTO                      = 94;
  SSL_CTRL_SET_SIGALGS                        = 97;
  SSL_CTRL_SET_SIGALGS_LIST                   = 98;
  SSL_CTRL_CERT_FLAGS                         = 99;
  SSL_CTRL_CLEAR_CERT_FLAGS                   = 100;
  SSL_CTRL_SET_CLIENT_SIGALGS                 = 101;
  SSL_CTRL_SET_CLIENT_SIGALGS_LIST            = 102;
  SSL_CTRL_GET_CLIENT_CERT_TYPES              = 103;
  SSL_CTRL_SET_CLIENT_CERT_TYPES              = 104;
  SSL_CTRL_BUILD_CERT_CHAIN                   = 105;
  SSL_CTRL_SET_VERIFY_CERT_STORE              = 106;
  SSL_CTRL_SET_CHAIN_CERT_STORE               = 107;
  SSL_CTRL_GET_PEER_SIGNATURE_NID             = 108;
  SSL_CTRL_GET_SERVER_TMP_KEY                 = 109;
  SSL_CTRL_GET_RAW_CIPHERLIST                 = 110;
  SSL_CTRL_GET_EC_POINT_FORMATS               = 111;
  SSL_CTRL_GET_TLSA_RECORD                    = 112;
  SSL_CTRL_SET_TLSA_RECORD                    = 113;
  SSL_CTRL_PULL_TLSA_RECORD                   = 114;
  SSL_CTRL_GET_CHAIN_CERTS                    = 115;
  SSL_CTRL_SELECT_CURRENT_CERT                = 116;
  SSL_CTRL_CHANNEL_ID                         = 117;
  SSL_CTRL_GET_CHANNEL_ID                     = 118;
  SSL_CTRL_SET_CHANNEL_ID                     = 119;
  SSL_CTRL_SET_MIN_PROTO_VERSION              = 123;
  SSL_CTRL_SET_MAX_PROTO_VERSION              = 124;

  DTLS_CTRL_GET_TIMEOUT            = 73;
  DTLS_CTRL_HANDLE_TIMEOUT         = 74;
  DTLS_CTRL_LISTEN       = 75;
  SSL_CTRL_GET_RI_SUPPORT    = 76;
  SSL_CTRL_CLEAR_OPTIONS     = 77;
  SSL_CTRL_CLEAR_MODE      = 78;

  TLSEXT_TYPE_server_name = 0;
  TLSEXT_TYPE_max_fragment_length = 1;
  TLSEXT_TYPE_client_certificate_url = 2;
  TLSEXT_TYPE_trusted_ca_keys = 3;
  TLSEXT_TYPE_truncated_hmac = 4;
  TLSEXT_TYPE_status_request = 5;
  TLSEXT_TYPE_user_mapping = 6;
  TLSEXT_TYPE_client_authz = 7;
  TLSEXT_TYPE_server_authz = 8;
  TLSEXT_TYPE_cert_type = 9;
  TLSEXT_TYPE_elliptic_curves = 10;
  TLSEXT_TYPE_ec_point_formats = 11;
  TLSEXT_TYPE_srp = 12;
  TLSEXT_TYPE_signature_algorithms = 13;
  TLSEXT_TYPE_use_srtp = 14;
  TLSEXT_TYPE_heartbeat = 15;
  TLSEXT_TYPE_session_ticket = 35;
  TLSEXT_TYPE_renegotiate = $ff01;
  TLSEXT_TYPE_next_proto_neg = 13172;
  TLSEXT_NAMETYPE_host_name = 0;
  TLSEXT_STATUSTYPE_ocsp = 1;
  TLSEXT_ECPOINTFORMAT_first = 0;
  TLSEXT_ECPOINTFORMAT_uncompressed = 0;
  TLSEXT_ECPOINTFORMAT_ansiX962_compressed_prime = 1;
  TLSEXT_ECPOINTFORMAT_ansiX962_compressed_char2 = 2;
  TLSEXT_ECPOINTFORMAT_last = 2;
  TLSEXT_signature_anonymous = 0;
  TLSEXT_signature_rsa = 1;
  TLSEXT_signature_dsa = 2;
  TLSEXT_signature_ecdsa = 3;
  TLSEXT_hash_none = 0;
  TLSEXT_hash_md5 = 1;
  TLSEXT_hash_sha1 = 2;
  TLSEXT_hash_sha224 = 3;
  TLSEXT_hash_sha256 = 4;
  TLSEXT_hash_sha384 = 5;
  TLSEXT_hash_sha512 = 6;
  TLSEXT_MAXLEN_host_name = 255;

  TLS1_VERSION = $0301;
  TLS1_1_VERSION = $0302;
  TLS1_2_VERSION = $0303;
  TLS1_3_VERSION = $0304;

  SSL_TLSEXT_ERR_OK = 0;
  SSL_TLSEXT_ERR_ALERT_WARNING = 1;
  SSL_TLSEXT_ERR_ALERT_FATAL = 2;
  SSL_TLSEXT_ERR_NOACK = 3;

  SSL_MODE_ENABLE_PARTIAL_WRITE                 = $00000001;
  SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER           = $00000002;
  SSL_MODE_AUTO_RETRY                           = $00000004;
  SSL_MODE_NO_AUTO_CHAIN                        = $00000008;
  SSL_MODE_RELEASE_BUFFERS                      = $00000010;

  SSL_OP_MICROSOFT_SESS_ID_BUG                  = $00000001;
  SSL_OP_NETSCAPE_CHALLENGE_BUG                 = $00000002;
  SSL_OP_LEGACY_SERVER_CONNECT                  = $00000004;
  SSL_OP_NETSCAPE_REUSE_CIPHER_CHANGE_BUG       = $00000008;
  SSL_OP_SSLREF2_REUSE_CERT_TYPE_BUG            = $00000010;
  SSL_OP_MICROSOFT_BIG_SSLV3_BUFFER             = $00000020;
  SSL_OP_MSIE_SSLV2_RSA_PADDING                 = $00000040;
  SSL_OP_SAFARI_ECDHE_ECDSA_BUG                 = $00000040;
  SSL_OP_SSLEAY_080_CLIENT_DH_BUG               = $00000080;
  SSL_OP_TLS_D5_BUG                             = $00000100;
  SSL_OP_TLS_BLOCK_PADDING_BUG                  = $00000200;
  SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS            = $00000800;
  SSL_OP_NO_QUERY_MTU                           = $00001000;
  SSL_OP_COOKIE_EXCHANGE                        = $00002000;
  SSL_OP_NO_TICKET                              = $00004000;
  SSL_OP_CISCO_ANYCONNECT                       = $00008000;
  SSL_OP_ALL                                    = $000FFFFF;
  SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION = $00010000;
  SSL_OP_NO_COMPRESSION                         = $00020000;
  SSL_OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION      = $00040000;
  SSL_OP_SINGLE_ECDH_USE                        = $00080000;
  SSL_OP_SINGLE_DH_USE                          = $00100000;
  SSL_OP_EPHEMERAL_RSA                          = $00200000;
  SSL_OP_CIPHER_SERVER_PREFERENCE               = $00400000;
  SSL_OP_TLS_ROLLBACK_BUG                       = $00800000;
  SSL_OP_NO_SSLv2                               = $01000000;
  SSL_OP_NO_SSLv3                               = $02000000;
  SSL_OP_NO_TLSv1                               = $04000000;
  SSL_OP_NO_TLSv1_2                             = $08000000;
  SSL_OP_NO_TLSv1_3                             = $20000000;
  SSL_OP_NO_TLSv1_1                             = $10000000;
  SSL_OP_NETSCAPE_CA_DN_BUG                     = $20000000;
  SSL_OP_NETSCAPE_DEMO_CIPHER_CHANGE_BUG        = $40000000;
  SSL_OP_CRYPTOPRO_TLSEXT_BUG                   = $80000000;

  SSL_VERIFY_NONE = $00;
  SSL_VERIFY_PEER = $01;

  SSL_CERT_FLAG_TLS_STRICT                      = $00000001;

  // Used in SSL_set_shutdown()/SSL_get_shutdown();
  SSL_SENT_SHUTDOWN = 1;
  SSL_RECEIVED_SHUTDOWN = 2;

  OPENSSL_DES_DECRYPT = 0;
  OPENSSL_DES_ENCRYPT = 1;

  X509_V_OK = 0;
  X509_V_ILLEGAL = 1;
  X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT = 2;
  X509_V_ERR_UNABLE_TO_GET_CRL = 3;
  X509_V_ERR_UNABLE_TO_DECRYPT_CERT_SIGNATURE = 4;
  X509_V_ERR_UNABLE_TO_DECRYPT_CRL_SIGNATURE = 5;
  X509_V_ERR_UNABLE_TO_DECODE_ISSUER_PUBLIC_KEY = 6;
  X509_V_ERR_CERT_SIGNATURE_FAILURE = 7;
  X509_V_ERR_CRL_SIGNATURE_FAILURE = 8;
  X509_V_ERR_CERT_NOT_YET_VALID = 9;
  X509_V_ERR_CERT_HAS_EXPIRED = 10;
  X509_V_ERR_CRL_NOT_YET_VALID = 11;
  X509_V_ERR_CRL_HAS_EXPIRED = 12;
  X509_V_ERR_ERROR_IN_CERT_NOT_BEFORE_FIELD = 13;
  X509_V_ERR_ERROR_IN_CERT_NOT_AFTER_FIELD = 14;
  X509_V_ERR_ERROR_IN_CRL_LAST_UPDATE_FIELD = 15;
  X509_V_ERR_ERROR_IN_CRL_NEXT_UPDATE_FIELD = 16;
  X509_V_ERR_OUT_OF_MEM = 17;
  X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT = 18;
  X509_V_ERR_SELF_SIGNED_CERT_IN_CHAIN = 19;
  X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY = 20;
  X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE = 21;
  X509_V_ERR_CERT_CHAIN_TOO_LONG = 22;
  X509_V_ERR_CERT_REVOKED = 23;
  X509_V_ERR_INVALID_CA = 24;
  X509_V_ERR_PATH_LENGTH_EXCEEDED = 25;
  X509_V_ERR_INVALID_PURPOSE = 26;
  X509_V_ERR_CERT_UNTRUSTED = 27;
  X509_V_ERR_CERT_REJECTED = 28;
  //These are 'informational' when looking for issuer cert
  X509_V_ERR_SUBJECT_ISSUER_MISMATCH = 29;
  X509_V_ERR_AKID_SKID_MISMATCH = 30;
  X509_V_ERR_AKID_ISSUER_SERIAL_MISMATCH = 31;
  X509_V_ERR_KEYUSAGE_NO_CERTSIGN = 32;
  X509_V_ERR_UNABLE_TO_GET_CRL_ISSUER = 33;
  X509_V_ERR_UNHANDLED_CRITICAL_EXTENSION = 34;
  //The application is not happy
  X509_V_ERR_APPLICATION_VERIFICATION = 50;

  SSL_FILETYPE_ASN1 = 2;
  SSL_FILETYPE_PEM = 1;

  // RSA
  RSA_PKCS1_PADDING      = 1;
  RSA_SSLV23_PADDING     = 2;
  RSA_NO_PADDING         = 3;
  RSA_PKCS1_OAEP_PADDING = 4;
  RSA_X931_PADDING       = 5;
  RSA_PKCS1_PSS_PADDING  = 6;
  RSA_PKCS1_WITH_TLS_PADDING = 7;
  RSA_PKCS1_NO_IMPLICIT_REJECT_PADDING = 8;
  RSA_PKCS1_PADDING_SIZE = 11;

  // RSA key exponent
  RSA_3: longint = $3;
  RSA_F4: longint = $10001;

  // ASN1 values
  V_ASN1_EOC                     = 0;
  V_ASN1_BOOLEAN                 = 1;
  V_ASN1_INTEGER                 = 2;
  V_ASN1_BIT_STRING              = 3;
  V_ASN1_OCTET_STRING            = 4;
  V_ASN1_NULL                    = 5;
  V_ASN1_OBJECT                  = 6;
  V_ASN1_OBJECT_DESCRIPTOR       = 7;
  V_ASN1_EXTERNAL                = 8;
  V_ASN1_REAL                    = 9;
  V_ASN1_ENUMERATED              = 10;
  V_ASN1_UTF8STRING              = 12;
  V_ASN1_SEQUENCE                = 16;
  V_ASN1_SET                     = 17;
  V_ASN1_NUMERICSTRING           = 18;
  V_ASN1_PRINTABLESTRING         = 19;
  V_ASN1_T61STRING               = 20;
  V_ASN1_TELETEXSTRING           = 20;
  V_ASN1_VIDEOTEXSTRING          = 21;
  V_ASN1_IA5STRING               = 22;
  V_ASN1_UTCTIME                 = 23;
  V_ASN1_GENERALIZEDTIME         = 24;
  V_ASN1_GRAPHICSTRING           = 25;
  V_ASN1_ISO64STRING             = 26;
  V_ASN1_VISIBLESTRING           = 26;
  V_ASN1_GENERALSTRING           = 27;
  V_ASN1_UNIVERSALSTRING         = 28;
  V_ASN1_BMPSTRING               = 30;

  MBSTRING_FLAG  = $1000;
  MBSTRING_UTF8 = MBSTRING_FLAG;
  MBSTRING_ASC = $1001;
  MBSTRING_BMP = $1002;
  MBSTRING_UNIV = $1004;

  // BN
{$ifdef cpu64}
// * 64-bit processor with LP64 ABI
type
  BN_ULONG = culong;
const
  BN_BYTES = 8;
{$else}
{$ifdef SIXTY_FOUR_BIT}
// * 64-bit processor other than LP64 ABI
type
  BN_ULONG = culonglong;
const
  BN_BYTES = 8;
{$else}
type
  BN_ULONG = cuint;
const
  BN_BYTES = 4;
{$endif}
{$endif}

  // BIO

  BIO_NOCLOSE         = $00;
  BIO_CLOSE           = $01;

  //* modifiers */
  BIO_FP_READ   = $02;
  BIO_FP_WRITE    = $04;
  BIO_FP_APPEND   = $08;
  BIO_FP_TEXT   = $10;

  BIO_C_SET_CONNECT                 = 100;
  BIO_C_DO_STATE_MACHINE            = 101;
  BIO_C_SET_NBIO              = 102;
  BIO_C_SET_PROXY_PARAM             = 103;
  BIO_C_SET_FD                      = 104;
  BIO_C_GET_FD                = 105;
  BIO_C_SET_FILE_PTR              = 106;
  BIO_C_GET_FILE_PTR              = 107;
  BIO_C_SET_FILENAME              = 108;
  BIO_C_SET_SSL               = 109;
  BIO_C_GET_SSL               = 110;
  BIO_C_SET_MD                = 111;
  BIO_C_GET_MD                      = 112;
  BIO_C_GET_CIPHER_STATUS           = 113;
  BIO_C_SET_BUF_MEM               = 114;
  BIO_C_GET_BUF_MEM_PTR       = 115;
  BIO_C_GET_BUFF_NUM_LINES          = 116;
  BIO_C_SET_BUFF_SIZE             = 117;
  BIO_C_SET_ACCEPT              = 118;
  BIO_C_SSL_MODE              = 119;
  BIO_C_GET_MD_CTX              = 120;
  BIO_C_GET_PROXY_PARAM             = 121;
  BIO_C_SET_BUFF_READ_DATA      = 122; // data to read first */
  BIO_C_GET_CONNECT       = 123;
  BIO_C_GET_ACCEPT        = 124;
  BIO_C_SET_SSL_RENEGOTIATE_BYTES   = 125;
  BIO_C_GET_SSL_NUM_RENEGOTIATES    = 126;
  BIO_C_SET_SSL_RENEGOTIATE_TIMEOUT = 127;
  BIO_C_FILE_SEEK       = 128;
  BIO_C_GET_CIPHER_CTX        = 129;
  BIO_C_SET_BUF_MEM_EOF_RETURN  = 130;//*return end of input value*/
  BIO_C_SET_BIND_MODE   = 131;
  BIO_C_GET_BIND_MODE   = 132;
  BIO_C_FILE_TELL   = 133;
  BIO_C_GET_SOCKS   = 134;
  BIO_C_SET_SOCKS   = 135;

  BIO_C_SET_WRITE_BUF_SIZE  = 136;//* for BIO_s_bio */
  BIO_C_GET_WRITE_BUF_SIZE  = 137;
  BIO_C_MAKE_BIO_PAIR   = 138;
  BIO_C_DESTROY_BIO_PAIR  = 139;
  BIO_C_GET_WRITE_GUARANTEE = 140;
  BIO_C_GET_READ_REQUEST  = 141;
  BIO_C_SHUTDOWN_WR   = 142;
  BIO_C_NREAD0            = 143;
  BIO_C_NREAD     = 144;
  BIO_C_NWRITE0     = 145;
  BIO_C_NWRITE      = 146;
  BIO_C_RESET_READ_REQUEST  = 147;
  BIO_C_SET_MD_CTX    = 148;

  BIO_C_SET_PREFIX    = 149;
  BIO_C_GET_PREFIX    = 150;
  BIO_C_SET_SUFFIX    = 151;
  BIO_C_GET_SUFFIX    = 152;

  BIO_C_SET_EX_ARG    = 153;
  BIO_C_GET_EX_ARG    = 154;

  BIO_CTRL_RESET  =    1  ; { opt - rewind/zero etc }
  BIO_CTRL_EOF    =    2  ; { opt - are we at the eof }
  BIO_CTRL_INFO   =     3  ; { opt - extra tit-bits }
  BIO_CTRL_SET    =     4  ; { man - set the 'IO' type }
  BIO_CTRL_GET    =     5  ; { man - get the 'IO' type }
  BIO_CTRL_PUSH   =     6  ; { opt - internal, used to signify change }
  BIO_CTRL_POP    =     7  ; { opt - internal, used to signify change }
  BIO_CTRL_GET_CLOSE =  8  ; { man - set the 'close' on free }
  BIO_CTRL_SET_CLOSE =  9  ; { man - set the 'close' on free }
  BIO_CTRL_PENDING   =  10  ; { opt - is their more data buffered }
  BIO_CTRL_FLUSH     =  11  ; { opt - 'flush' buffered output }
  BIO_CTRL_DUP       =  12  ; { man - extra stuff for 'duped' BIO }
  BIO_CTRL_WPENDING  =  13  ; { opt - number of bytes still to write }
  BIO_CTRL_SET_CALLBACK   = 14  ; { opt - set callback function }
  BIO_CTRL_GET_CALLBACK   = 15  ; { opt - set callback function }
  BIO_CTRL_SET_FILENAME   = 30  ; { BIO_s_file special }
  BIO_CTRL_DGRAM_CONNECT  = 31  ; { BIO dgram special }
  BIO_CTRL_DGRAM_SET_CONNECTED      = 32  ; { allow for an externally }
  BIO_CTRL_DGRAM_SET_RECV_TIMEOUT   = 33 ; { setsockopt, essentially }
  BIO_CTRL_DGRAM_GET_RECV_TIMEOUT   = 34 ; { getsockopt, essentially }
  BIO_CTRL_DGRAM_SET_SEND_TIMEOUT   = 35 ; { setsockopt, essentially }
  BIO_CTRL_DGRAM_GET_SEND_TIMEOUT   = 36 ; { getsockopt, essentially }
  BIO_CTRL_DGRAM_GET_RECV_TIMER_EXP = 37 ; { flag whether the last }
  BIO_CTRL_DGRAM_GET_SEND_TIMER_EXP = 38 ; { I/O operation tiemd out }
  BIO_CTRL_DGRAM_MTU_DISCOVER       = 39 ; { set DF bit on egress packets }
  BIO_CTRL_DGRAM_QUERY_MTU          = 40 ; { as kernel for current MTU }
  BIO_CTRL_DGRAM_GET_FALLBACK_MTU   = 47 ;
  BIO_CTRL_DGRAM_GET_MTU            = 41 ; { get cached value for MTU }
  BIO_CTRL_DGRAM_SET_MTU            = 42 ; { set cached value for }
  BIO_CTRL_DGRAM_MTU_EXCEEDED       = 43 ; { check whether the MTU }
  BIO_CTRL_DGRAM_GET_PEER           = 46 ;
  BIO_CTRL_DGRAM_SET_PEER           = 44 ; { Destination for the data }
  BIO_CTRL_DGRAM_SET_NEXT_TIMEOUT   = 45 ; { Next DTLS handshake timeout to }
  BIO_CTRL_DGRAM_SCTP_SET_IN_HANDSHAKE = 50;
  BIO_CTRL_DGRAM_SCTP_ADD_AUTH_KEY     = 51;
  BIO_CTRL_DGRAM_SCTP_NEXT_AUTH_KEY    = 52;
  BIO_CTRL_DGRAM_SCTP_AUTH_CCS_RCVD    = 53;
  BIO_CTRL_DGRAM_SCTP_GET_SNDINFO      = 60;
  BIO_CTRL_DGRAM_SCTP_SET_SNDINFO      = 61;
  BIO_CTRL_DGRAM_SCTP_GET_RCVINFO      = 62;
  BIO_CTRL_DGRAM_SCTP_SET_RCVINFO      = 63;
  BIO_CTRL_DGRAM_SCTP_GET_PRINFO       = 64;
  BIO_CTRL_DGRAM_SCTP_SET_PRINFO       = 65;
  BIO_CTRL_DGRAM_SCTP_SAVE_SHUTDOWN    = 70;

//DES modes
  DES_ENCRYPT = 1;
  DES_DECRYPT = 0;

  XN_FLAG_SEP_MASK       = 983040;  //(0xf << 16)
  XN_FLAG_SEP_CPLUS_SPC  = 131072;  //(2 << 16) ,+ spaced: more readable
  ASN1_STRFLGS_UTF8_CONVERT = 16;

// Error codes for ECDH Function
  ECDH_F_ECDH_COMPUTE_KEY = 100;
  ECDH_F_ECDH_DATA_NEW_METHOD = 101;

// Error codes for ECDH Reason
  ECDH_R_NO_PRIVATE_VALUE = 100;
  ECDH_R_POINT_ARITHMETIC_FAILURE = 101;
  ECDH_R_KDF_FAILED = 102;

var
  SSLLibPath: String = '';
  SSLLibHandle: TLibHandle = 0;
  SSLUtilHandle: TLibHandle = 0;
  SSLLibFile: String = '';
  SSLUtilFile: String = '';

// libssl.dll
  function OpenSSLVersion(t: cint): AnsiString;
  function OpenSSLVersionNum(): cLong;
  function OpenSSLFullVersion: String;
  function IsOpenSSL3: Boolean;

  function SSLeay_version(t: cInt): AnsiString;
  function SslGetError(s: PSSL; ret_code: cInt):cInt;
  function SslLibraryInit:cInt;
  procedure SslLoadErrorStrings;
  function SslCtxSetCipherList(arg0: PSSL_CTX; var str: AnsiString):cInt;
  function SslCtxNew(meth: PSSL_METHOD):PSSL_CTX;
  procedure SslCtxFree(arg0: PSSL_CTX);
  function SslSetFd(s: PSSL; fd: cInt):cInt;

  function SslCtrl(ssl: PSSL; cmd: cInt; larg: clong; parg: Pointer): cLong;
  function SslCTXCtrl(ctx: PSSL_CTX; cmd: cInt; larg: clong; parg: Pointer): cLong;
  function SslCtxSetMinProtoVersion(ctx: PSSL_CTX; version: integer): integer;
  function SslCtxSetMaxProtoVersion(ctx: PSSL_CTX; version: integer): integer;
  function SSLCTXSetMode(ctx: PSSL_CTX; mode: cLong): cLong;
  function SSLSetMode(s: PSSL; mode: cLong): cLong;
  function SSLCTXGetMode(ctx: PSSL_CTX): cLong;
  function SSLGetMode(s: PSSL): cLong;

  function SslMethodV2:PSSL_METHOD;
  function SslMethodV3:PSSL_METHOD;
  function SslMethodTLSV1:PSSL_METHOD;
  function SslMethodTLSV1_1:PSSL_METHOD;
  function SslMethodTLSV1_2:PSSL_METHOD;
  function SslMethodV23:PSSL_METHOD;
  function SslTLSMethod:PSSL_METHOD;
  function SslCtxUsePrivateKey(ctx: PSSL_CTX; pkey: SslPtr):cInt;
  function SslCtxUsePrivateKeyASN1(pk: cInt; ctx: PSSL_CTX; d: AnsiString; len: cLong):cInt;overload;
  function SslCtxUsePrivateKeyASN1(pk: cInt; ctx: PSSL_CTX; b: TBytes; len: cLong):cInt;overload;
  function SslCtxUsePrivateKeyFile(ctx: PSSL_CTX; const _file: AnsiString; _type: cInt):cInt;
  function SslCtxUseCertificate(ctx: PSSL_CTX; x: SslPtr):cInt;
  function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: cLong; d: AnsiString):cInt; overload;
  function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: cLong; Buf: TBytes):cInt; overload;
  function SslCtxUseCertificateFile(ctx: PSSL_CTX; const _file: AnsiString; _type: cInt):cInt;
  function SslCtxUseCertificateChainFile(ctx: PSSL_CTX; const _file: AnsiString):cInt;
  function SslCtxCheckPrivateKeyFile(ctx: PSSL_CTX):cInt;
  procedure SslCtxSetDefaultPasswdCb(ctx: PSSL_CTX; cb: PPasswdCb);
  procedure SslCtxSetDefaultPasswdCbUserdata(ctx: PSSL_CTX; u: SslPtr);
  function SslCtxLoadVerifyLocations(ctx: PSSL_CTX; const CAfile: AnsiString; const CApath: AnsiString):cInt;
  function SslNew(ctx: PSSL_CTX):PSSL;
  procedure SslFree(ssl: PSSL);
  function SslAccept(ssl: PSSL):cInt;
  function SslConnect(ssl: PSSL):cInt;
  function SslShutdown(ssl: PSSL):cInt;
  function SslRead(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
  function SslPeek(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
  function SslWrite(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
  function SslPending(ssl: PSSL):cInt;
  function SslGetVersion(ssl: PSSL): AnsiString;
  function SslGetPeerCertificate(ssl: PSSL):PX509;
  procedure SslCtxSetVerify(ctx: PSSL_CTX; mode: cInt; arg2: TSSLCTXVerifyCallback);
  function SSLGetCurrentCipher(s: PSSL):SslPtr;
  function SSLCipherGetName(c: SslPtr): AnsiString;
  function SSLCipherGetBits(c: SslPtr; var alg_bits: cInt):cInt;
  function SSLGetVerifyResult(ssl: PSSL):cLong;
  function SSLGetServername(ssl: PSSL; _type: cInt = TLSEXT_NAMETYPE_host_name): AnsiString;
  procedure SslCtxCallbackCtrl(ssl: PSSL; _type: cInt; cb: PCallbackCb);
  function SslSetSslCtx(ssl: PSSL; ctx: PSSL_CTX): PSSL;

// libeay.dll
  procedure ERR_load_crypto_strings;
  function X509New: PX509;
  procedure X509Free(x: PX509);
  function X509_NAME_new():PX509_NAME;
  procedure X509_NAME_free(a: PX509_NAME);
  function X509NAMEprintEx(b: PBIO; x: PX509_NAME; indent: cInt; flags: cuint): cInt;
  function X509NameOneline(a: PX509_NAME; var buf: AnsiString; size: cInt): AnsiString;
  function X509GetSubjectName(a: PX509):PX509_NAME;
  function X509GetIssuerName(a: PX509):PX509_NAME;
  function X509NameHash(x: PX509_NAME):cuLong;
  function X509Digest(data: PX509; _type: PEVP_MD; md: AnsiString; var len: cInt):cInt;
  function X509print(b: PBIO; a: PX509): cInt;
  function X509SetVersion(x: PX509; version: cInt): cInt;
  function X509SetPubkey(x: PX509; pkey: PEVP_PKEY): cInt;
  function X509GetPubkey(x: PX509): PEVP_PKEY;
  function X509SetIssuerName(x: PX509; name: PX509_NAME): cInt;
  function X509NameAddEntryByTxt(name: PX509_NAME; field: Ansistring; _type:
                 cInt; bytes: AnsiString; len, loc, _set: cInt): cInt;
  function X509Sign(x: PX509; pkey: PEVP_PKEY; const md: PEVP_MD): cInt;
  function X509GmtimeAdj(s: PASN1_UTCTIME; adj: cInt): PASN1_UTCTIME;
  function X509GetNotBefore(x: pX509): pASN1_TIME;
  function X509GetNotAfter(x: pX509): pASN1_TIME;
  function X509SetNotBefore(x: PX509; tm: PASN1_UTCTIME): cInt;
  function X509SetNotAfter(x: PX509; tm: PASN1_UTCTIME): cInt;
  function X509GetSerialNumber(x: PX509): PASN1_cInt;
  function X509GetExt(x: PX509; loc: integer): pX509_EXTENSION;
  function X509ExtensionGetData(ext: pX509_EXTENSION): pASN1_STRING;

  function X509_REQ_new: PX509_REQ;
  procedure X509_REQ_free(x: PX509_REQ);
  function X509_REQ_set_subject_name(req: PX509_REQ; name: PX509_NAME): cInt;
  function X509_REQ_set_pubkey(x: PX509_REQ; pkey: PEVP_PKEY): cInt;
  function X509_REQ_sign(x: PX509_REQ; pkey: PEVP_PKEY; const md: PEVP_MD): cInt;

  function EvpPkeyNew: PEVP_PKEY;
  procedure EvpPkeyFree(pk: PEVP_PKEY);
  function EvpPkeyAssign(pkey: PEVP_PKEY; _type: cInt; key: Prsa): cInt;
  function EvpPkeyGet1RSA(pkey: PEVP_PKEY): pRSA;
  function EvpPkeySet1RSA(pkey: PEVP_PKEY; rsa: pRSA): cInt;
  function EvpGetDigestByName(Name: AnsiString): PEVP_MD;
  procedure EVPcleanup;
  procedure ErrErrorString(e: cInt; var buf: AnsiString; len: cInt);
  function ErrGetError: cInt;
  procedure ErrClearError;
  procedure ErrFreeStrings;
  procedure ErrRemoveState(pid: cInt);
  procedure RandScreen;
  function d2iPKCS12bio(b:PBIO; Pkcs12: SslPtr): SslPtr;
  function PKCS12parse(p12: SslPtr; pass: AnsiString; var pkey: pEVP_PKEY;
     var cert: pX509; var ca: SslPtr): cInt;
  procedure PKCS12free(p12: SslPtr);
  function Asn1StringTypeNew(aType : cint): PASN1_STRING;
  Function Asn1UtctimePrint(b : PBio; a: PASN1_UTCTIME) : integer;
  Function ASN1UtcTimeSetString(t : PASN1_UTCTIME; s : PAnsichar) : cint;
  function Asn1UtctimeNew: PASN1_UTCTIME;
  procedure Asn1UtctimeFree(a: PASN1_UTCTIME);
  function Asn1IntegerSet(a: PASN1_INTEGER; v: integer): integer;
  function Asn1IntegerGet(a: PASN1_INTEGER): integer;
  function i2dX509bio(b: PBIO; x: PX509): cInt;
  function d2iX509bio(b: pBIO; x: PX509): PX509;
  function i2dPrivateKeyBio(b: PBIO; pkey: PEVP_PKEY): cInt;
  function OPENSSL_sk_num(Stack: PSTACK): Integer;
  function OPENSSL_sk_value(Stack: PSTACK; Item: Integer): PAnsiChar;
  procedure OPENSSL_sk_pop_free(Stack: PSTACK; func: Tsk_pop_free_func);
  function X509_STORE_add_cert(Store: PX509_STORE; Cert: PX509): Integer;
  function SSL_CTX_get_cert_store(const Ctx: PSSL_CTX): PX509_STORE;

  // 3DES functions
  procedure DESsetoddparity(Key: des_cblock);
  function DESsetkey(key: des_cblock; schedule: des_key_schedule): cInt;
  function DESsetkeychecked(key: des_cblock; schedule: des_key_schedule): cInt;
  procedure DESecbencrypt(Input: des_cblock; output: des_cblock; ks: des_key_schedule; enc: cInt);

  // RAND functions
  function RAND_set_rand_method(const meth: PRAND_METHOD): cint;
  function RAND_get_rand_method: PRAND_METHOD;
  function RAND_SSLeay: PRAND_METHOD;
  procedure RAND_cleanup;
  function RAND_bytes(buf: PByte; num: cint): cint;
  function RAND_pseudo_bytes(buf: PByte; num: cint): cint;
  procedure RAND_seed(const buf: Pointer; num: cint);
  procedure RAND_add(const buf: Pointer; num: cint; entropy: cdouble);
  function RAND_load_file(const file_name: PAnsiChar; max_bytes: clong): cint;
  function RAND_write_file(const file_name: PAnsiChar): cint;
  function RAND_file_name(file_name: PAnsiChar; num: csize_t): PAnsiChar;
  function RAND_status: cint;
  function RAND_query_egd_bytes(const path: PAnsiChar; buf: PByte; bytes: cint): cint;
  function RAND_egd(const path: PAnsiChar): cint;
  function RAND_egd_bytes(const path: PAnsiChar; bytes: cint): cint;
  procedure ERR_load_RAND_strings;
  function RAND_poll: cint;

  // RSA Functions
  function RSA_new(): PRSA;
  function RSA_new_method(method: PENGINE): PRSA;
  function RSA_size(arsa: PRSA): cint;
  // Deprecated Function: Don't use!
  // For compatibility with previous versions of this file
  function RsaGenerateKey(bits, e: cInt; callback: PFunction; cb_arg: SslPtr): PRSA;
  // New version of the previous deprecated routine
  function RSA_generate_key_ex(arsa: PRSA; bits: cInt; e: PBIGNUM; cb: PBN_GENCB): cint;
  //
  function RSA_check_key(arsa: PRSA): cint;
  // Next 4 return -1 on error
  function RSA_public_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
  function RSA_private_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
  function RSA_public_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
  function RSA_private_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
  procedure RSA_free(arsa: PRSA);
  //
  // RSA_up_flags
  function RSA_flags(arsa: PRSA): Integer;
  //
  procedure RSA_set_default_method(method: PRSA_METHOD);
  function RSA_get_default_method: PRSA_METHOD;
  function RSA_get_method(arsa: PRSA): PRSA_METHOD;
  function RSA_set_method(arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD;
  //
  function RSA_get0_n(const d :PRSA): PBIGNUM;
  function RSA_get0_e(const d :PRSA): PBIGNUM;
  function RSA_get0_d(const d :PRSA): PBIGNUM;
  function RSA_get0_p(const d :PRSA): PBIGNUM;
  function RSA_get0_q(const d :PRSA): PBIGNUM;
  function RSA_set0_key(r: pRSA; n: PBIGNUM; e: PBIGNUM; d: PBIGNUM): cint;

  function RSA_get_version(r :PRSA): cint;
  function RSA_pkey_ctx_ctrl(ctx: PEVP_PKEY_CTX; optype: cint; cmd: cint; p1: cint; p2: Pointer): cint;
  //
  // RSA_memory_lock

  // X509 Functions
  function d2i_RSAPublicKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
  function i2d_RSAPublicKey(arsa: PRSA; pp: PPByte): cint;
  function d2i_RSAPrivateKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
  function i2d_RSAPrivateKey(arsa: PRSA; pp: PPByte): cint;

  function d2i_PubKey(a: PPEVP_PKEY; pp: PPByte; len: clong): PEVP_PKEY;
  function d2i_AutoPrivateKey(a: PPEVP_PKEY; pp: PPByte; len: clong): PEVP_PKEY;

  // ERR Functions
  function Err_Error_String(e: cInt; buf: PAnsiChar): PAnsiChar;

  // EVP Functions - evp.h
  function EVP_des_ede3_cbc : PEVP_CIPHER;
  Function EVP_enc_null : PEVP_CIPHER;
  Function EVP_rc2_cbc : PEVP_CIPHER;
  Function EVP_rc2_40_cbc : PEVP_CIPHER;
  Function EVP_rc2_64_cbc : PEVP_CIPHER;
  Function EVP_rc4 : PEVP_CIPHER;
  Function EVP_rc4_40 : PEVP_CIPHER;
  Function EVP_des_cbc : PEVP_CIPHER;
  Function EVP_aes_128_cbc : PEVP_CIPHER;
  Function EVP_aes_192_cbc : PEVP_CIPHER;
  Function EVP_aes_256_cbc : PEVP_CIPHER;
  Function EVP_aes_128_cfb8 : PEVP_CIPHER;
  Function EVP_aes_192_cfb8 : PEVP_CIPHER;
  Function EVP_aes_256_cfb8 : PEVP_CIPHER;
  Function EVP_camellia_128_cbc : PEVP_CIPHER;
  Function EVP_camellia_192_cbc : PEVP_CIPHER;
  Function EVP_camellia_256_cbc : PEVP_CIPHER;
  function EVP_sha256: PEVP_CIPHER;

  procedure OpenSSL_add_all_algorithms;
  procedure OpenSSL_add_all_ciphers;
  procedure OpenSSL_add_all_digests;
  //
  function EVP_DigestInit(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint;
  function EVP_DigestUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
  function EVP_DigestFinal(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint;
  function EVP_SignFinal(ctx: pEVP_MD_CTX; sig: pointer; var s: cardinal;
    key: pEVP_PKEY): integer;
  function EVP_PKEY_size(key: pEVP_PKEY): integer;
  procedure EVP_PKEY_free(key: pEVP_PKEY);
  function EVP_PKEY_new_mac_key(type_: cint; e: PENGINE; key: PByte; keylen :cint): PEVP_PKEY;  // Tz HMAC
  function EVP_VerifyFinal(ctx: pEVP_MD_CTX; sigbuf: pointer;
    siglen: cardinal; pkey: pEVP_PKEY): integer;
  //
  function EVP_get_cipherbyname(const name: PAnsiChar): PEVP_CIPHER;
  function EVP_get_digestbyname(const name: PAnsiChar): PEVP_MD;
  //
  procedure EVP_CIPHER_CTX_init(a: PEVP_CIPHER_CTX);
  function EVP_CIPHER_CTX_cleanup(a: PEVP_CIPHER_CTX): cint;
  function EVP_CIPHER_CTX_new: PEVP_CIPHER_CTX;             // Tz Cipher
  procedure EVP_CIPHER_CTX_free(ctx :PEVP_CIPHER_CTX);      // Tz Cipher
  function EVP_CIPHER_CTX_set_key_length(x: PEVP_CIPHER_CTX; keylen: cint): cint;
  function EVP_CIPHER_CTX_ctrl(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint;
  //
  function EVP_EncryptInit(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER;
           const key, iv: PByte): cint;
  function EVP_EncryptUpdate(ctx: PEVP_CIPHER_CTX; out_: pcuchar;
           outlen: pcint; const in_: pcuchar; inlen: cint): cint;
  function EVP_EncryptFinal(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint;
  //
  function EVP_DecryptInit(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER;
           const key, iv: PByte): cint;
  function EVP_DecryptUpdate(ctx: PEVP_CIPHER_CTX; out_data: PByte;
           outl: pcint; const in_: PByte; inl: cint): cint;
  function EVP_DecryptFinal(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint;
  //
  function EVP_MD_CTX_new: PEVP_MD_CTX;
  function EVP_MD_CTX_create: PEVP_MD_CTX;
  procedure EVP_MD_CTX_destroy(ctx: PEVP_MD_CTX);
  procedure EVP_MD_CTX_free(ctx: PEVP_MD_CTX);

  function EVP_PKEY_CTX_new(pkey: PEVP_PKEY; e: PENGINE): PEVP_PKEY_CTX;
  procedure EVP_PKEY_CTX_free(ctx: PEVP_PKEY_CTX);
  function EVP_PKEY_CTX_ctrl(ctx: PEVP_PKEY_CTX; keytype: cint; optype: cint; cmd: cint; p1: cint; p2: Pointer): cint;
  function EVP_PKEY_CTX_set_rsa_padding(ctx: PEVP_PKEY_CTX; pad: cint): cint;
  function EVP_PKEY_CTX_set_rsa_oaep_md(ctx: PEVP_PKEY_CTX; const md: PEVP_MD): cint;
  function EVP_PKEY_CTX_set_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; const md: PEVP_MD): cint;
  function EVP_PKEY_encrypt_init(ctx: PEVP_PKEY_CTX): cint;
  function EVP_PKEY_encrypt(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint; const in_data: PByte; inlen: csize_t): cint;
  function EVP_PKEY_decrypt_init(ctx: PEVP_PKEY_CTX): cint;
  function EVP_PKEY_decrypt(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint; const in_data: PByte; inlen: csize_t): cint;

  function EVP_DigestSignInit(ctx: PEVP_MD_CTX; pctx: PPEVP_PKEY_CTX; const evptype: PEVP_MD; e: PENGINE; pkey: PEVP_PKEY): cint;
  function EVP_DigestSignUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
  function EVP_DigestSignFinal(ctx: PEVP_MD_CTX; sigret: PByte; siglen: pcsize_t): cint;
  function EVP_DigestVerifyInit(ctx: PEVP_MD_CTX; pctx: PPEVP_PKEY_CTX; const evptype: PEVP_MD; e: PENGINE; pkey: PEVP_PKEY): cint;
  function EVP_DigestVerifyUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
  function EVP_DigestVerifyFinal(ctx: PEVP_MD_CTX; sig: PByte; siglen: csize_t): cint;
  //function
  //
  // PEM Functions - pem.h
  //
  function PEM_read_bio_PrivateKey(bp: PBIO; X: PPEVP_PKEY;
           cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
  function PEM_read_bio_PUBKEY(bp: pBIO; var x: pEVP_PKEY;
               cb: Ppem_password_cb; u: pointer): pEVP_PKEY;
  function PEM_write_bio_PrivateKey(bp: pBIO; x: pEVP_PKEY;
               const enc: pEVP_CIPHER; kstr: PAnsiChar; klen: Integer; cb: Ppem_password_cb;
               u: pointer): integer;
  function PEM_write_bio_PUBKEY(bp: pBIO; x: pEVP_PKEY): integer;
  function PEM_read_bio_X509(bp: PBIO; x: PPX509; cb: ppem_password_cb; u: pointer): PX509;
  function PEM_write_bio_X509(bp: pBIO;  x: px509): integer;
  function PEM_write_bio_X509_REQ(bp: pBIO;  x: PX509_REQ): integer;
  function PEM_write_bio_PKCS7(bp : PBIO; x : PPKCS7) : cint;
  function PEM_read_bio_RSAPrivateKey(bp: pBIO; var x: pRSA;
      cb: Ppem_password_cb; u: pointer): pRSA;
  function PEM_write_bio_RSAPrivateKey(bp: pBIO; x: pRSA; const enc: pEVP_CIPHER;
      kstr: PAnsiChar; klen: integer; cb: Ppem_password_cb;
      u: pointer): integer;
  function PEM_read_bio_RSAPublicKey(bp: pBIO; var x: pRSA;
      cb: Ppem_password_cb; u: pointer): pRSA;
  function PEM_write_bio_RSAPublicKey(bp: pBIO; x: pRSA): integer;

  // BIO Functions - bio.h
  function BioNew(b: PBIO_METHOD): PBIO;
  procedure BioFreeAll(b: PBIO);
  function BioSMem: PBIO_METHOD;
  function BioCtrlPending(b: PBIO): cInt;
  function BioRead(b: PBIO; var Buf: AnsiString; Len: cInt): cInt; overload;
  function BioRead(b: PBIO; Buf: TBytes; Len: cInt): cInt; overload;
  function BioWrite(b: PBIO; Buf: AnsiString; Len: cInt): cInt; overload;
  function BioWrite(b: PBIO; Buf: TBytes; Len: cInt): cInt; overload;
  function BIO_ctrl(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong;
  function BIO_read_filename(b: PBIO; const name: PAnsiChar): cint;
  function BIOReset(b: pBIO): cint;

  function BIO_s_file: pBIO_METHOD;
  function BIO_new_file(const filename: PAnsiChar; const mode: PAnsiChar): pBIO;
  function BIO_new_mem_buf(buf: pointer; len: integer): pBIO;
  procedure CRYPTOcleanupAllExData;
  procedure OPENSSLaddallalgorithms;

  // PKCS7 functions
  function PKCS7_ISSUER_AND_SERIAL_new : PPKCS7_ISSUER_AND_SERIAL;
  procedure PKCS7_ISSUER_AND_SERIAL_free (a:PPKCS7_ISSUER_AND_SERIAL);
  function PKCS7_ISSUER_AND_SERIAL_digest(data:PPKCS7_ISSUER_AND_SERIAL; _type:PEVP_MD; md:Pbyte; len:Pdword):longint;
  function PKCS7_dup(p7:PPKCS7):PPKCS7;
  function PEM_write_bio_PKCS7_stream(_out:PBIO; p7:PPKCS7; _in:PBIO; flags:longint):longint;
  function PKCS7_SIGNER_INFO_new:PPKCS7_SIGNER_INFO;
  procedure PKCS7_SIGNER_INFO_free(a:PPKCS7_SIGNER_INFO);
  function PKCS7_RECIP_INFO_new:PPKCS7_RECIP_INFO;
  procedure PKCS7_RECIP_INFO_free(a:PPKCS7_RECIP_INFO);
  function PKCS7_SIGNED_new:PPKCS7_SIGNED;
  procedure PKCS7_SIGNED_free(a:PPKCS7_SIGNED);
  function PKCS7_ENC_CONTENT_new:PPKCS7_ENC_CONTENT;
  procedure PKCS7_ENC_CONTENT_free(a:PPKCS7_ENC_CONTENT);
  function PKCS7_ENVELOPE_new:PPKCS7_ENVELOPE;
  procedure PKCS7_ENVELOPE_free(a:PPKCS7_ENVELOPE);
  function PKCS7_SIGN_ENVELOPE_new:PPKCS7_SIGN_ENVELOPE;
  procedure PKCS7_SIGN_ENVELOPE_free(a:PPKCS7_SIGN_ENVELOPE);
  function PKCS7_DIGEST_new:PPKCS7_DIGEST;
  procedure PKCS7_DIGEST_free(a:PPKCS7_DIGEST);
  function PKCS7_ENCRYPT_new:PPKCS7_ENCRYPT;
  procedure PKCS7_ENCRYPT_free(a:PPKCS7_ENCRYPT);
  function PKCS7_new:PPKCS7;
  procedure PKCS7_free(a:PPKCS7);
  function PKCS7_print_ctx(_out:PBIO; x:PPKCS7; indent:longint; pctx:Pointer):longint;
  function PKCS7_ctrl(p7:PPKCS7; cmd:longint; larg:longint; parg: PAnsiChar):longint;
  function PKCS7_set_type(p7:PPKCS7; _type:longint):longint;
  function PKCS7_set0_type_other(p7:PPKCS7; _type:longint; other:PASN1_TYPE):longint;
  function PKCS7_set_content(p7:PPKCS7; p7_data:PPKCS7):longint;
  function PKCS7_SIGNER_INFO_set(p7i:PPKCS7_SIGNER_INFO; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):longint;
  function PKCS7_SIGNER_INFO_sign(si:PPKCS7_SIGNER_INFO):longint;
  function PKCS7_add_signer(p7:PPKCS7; p7i:PPKCS7_SIGNER_INFO):longint;
  function PKCS7_add_certificate(p7:PPKCS7; x509:PX509):longint;
  function PKCS7_add_crl(p7:PPKCS7; x509: Pointer):longint;
  function PKCS7_content_new(p7:PPKCS7; nid:longint):longint;
  function PKCS7_add_signature(p7:PPKCS7; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):PPKCS7_SIGNER_INFO;
  function PKCS7_cert_from_signer_info(p7:PPKCS7; si:PPKCS7_SIGNER_INFO):PX509;
  function PKCS7_set_digest(p7:PPKCS7; md:PEVP_MD):longint;
  function PKCS7_add_recipient(p7:PPKCS7; x509:PX509):PPKCS7_RECIP_INFO;
  function PKCS7_add_recipient_info(p7:PPKCS7; ri:PPKCS7_RECIP_INFO):longint;
  function PKCS7_RECIP_INFO_set(p7i:PPKCS7_RECIP_INFO; x509:PX509):longint;
  function PKCS7_set_cipher(p7:PPKCS7; cipher:PEVP_CIPHER):longint;
  function PKCS7_get_issuer_and_serial(p7:PPKCS7; idx:longint):PPKCS7_ISSUER_AND_SERIAL;
  function PKCS7_digest_from_attributes(sk:Pstack_st_X509_ATTRIBUTE):Pointer;
  function PKCS7_add_signed_attribute(p7si:PPKCS7_SIGNER_INFO; nid:longint; _type:longint; data:pointer):longint;
  function PKCS7_add_attribute(p7si:PPKCS7_SIGNER_INFO; nid:longint; atrtype:longint; value:pointer):longint;
  function PKCS7_get_attribute(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;
  function PKCS7_get_signed_attribute(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;
  function PKCS7_set_signed_attributes(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;
  function PKCS7_set_attributes(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;
  function PKCS7_sign(signcert:PX509; pkey:PEVP_PKEY; certs:Pstack_st_X509; data:PBIO; flags:longint):PPKCS7;
  function PKCS7_sign_add_signer(p7:PPKCS7; signcert:PX509; pkey:PEVP_PKEY; md:PEVP_MD; flags:longint):PPKCS7_SIGNER_INFO;
  function PKCS7_final(p7:PPKCS7; data:PBIO; flags:longint):longint;
  function PKCS7_verify(p7:PPKCS7; certs:Pstack_st_X509; store: Pointer; indata:PBIO; _out:PBIO;  flags:longint):longint;
  function PKCS7_encrypt(certs:Pstack_st_X509; _in:PBIO; cipher:PEVP_CIPHER; flags:longint):PPKCS7;
  function PKCS7_decrypt(p7:PPKCS7; pkey:PEVP_PKEY; cert:PX509; data:PBIO; flags:longint):longint;
  function PKCS7_add_attrib_smimecap(si:PPKCS7_SIGNER_INFO; cap:Pstack_st_X509_ALGOR):longint;
  function PKCS7_simple_smimecap(sk:Pstack_st_X509_ALGOR; nid:longint; arg:longint):longint;
  function PKCS7_add_attrib_content_type(si:PPKCS7_SIGNER_INFO; coid:Pointer):longint;
  function PKCS7_add0_attrib_signing_time(si:PPKCS7_SIGNER_INFO; t:PASN1_TIME):longint;
  function PKCS7_add1_attrib_digest(si:PPKCS7_SIGNER_INFO; md:Pbyte; mdlen:longint):longint;
  function BIO_new_PKCS7(_out:PBIO; p7:PPKCS7):PBIO;
  procedure ERR_load_PKCS7_strings;

  // BN functions
  function BN_new:PBIGNUM;
  function BN_secure_new:PBIGNUM;
  procedure BN_clear_free(a:PBIGNUM);
  function BN_copy(a:PBIGNUM; b:PBIGNUM):PBIGNUM;
  procedure BN_swap(a:PBIGNUM; b:PBIGNUM);
  function BN_print(fp: pBIO; const a: PBIGNUM): cint;
  function BN_hex2bn(var n: PBIGNUM; const str: PAnsiChar): cint;
  function BN_dec2bn(var n: PBIGNUM; const str: PAnsiChar): cint;
  function BN_bn2hex(const n: PBIGNUM): PAnsiChar;
  function BN_bn2dec(const n: PBIGNUM): PAnsiChar;
  function BN_bin2bn(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM;
  function BN_bn2bin(a:PBIGNUM; _to:pcuchar):cint;
  function BN_bn2binpad(a:PBIGNUM; _to:pcuchar; tolen:cint):cint;
  function BN_lebin2bn(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM;
  function BN_bn2lebinpad(a:PBIGNUM; _to:pcuchar; tolen:cint):cint;
  function BN_mpi2bn(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM;
  function BN_bn2mpi(a:PBIGNUM; _to:pcuchar):cint;
  function BN_sub(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint;
  function BN_usub(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint;
  function BN_uadd(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint;
  function BN_add(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint;
  function BN_mul(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_sqr(r:PBIGNUM; a:PBIGNUM; ctx:PBN_CTX):cint;
  // BN_set_negative sets sign of a BIGNUM
  // \param  b  pointer to the BIGNUM object
  // \param  n  0 if the BIGNUM b should be positive and a value != 0 otherwise
  procedure BN_set_negative(b:PBIGNUM; n:cint);
  // BN_is_negative returns 1 if the BIGNUM is negative
  // \param  b  pointer to the BIGNUM object
  // \return 1 if a < 0 and 0 otherwise
  function BN_is_negative(b:PBIGNUM):cint;
  function BN_div(dv:PBIGNUM; rem:PBIGNUM; m:PBIGNUM; d:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod(rem: PBIGNUM; a:PBIGNUM; m: PBIGNUM; ctx : PBN_CTX) : cint;
  function BN_nnmod(r:PBIGNUM; m:PBIGNUM; d:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_add(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_add_quick(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM):cint;
  function BN_mod_sub(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_sub_quick(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM):cint;
  function BN_mod_mul(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_sqr(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_lshift1(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_lshift1_quick(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM):cint;
  function BN_mod_lshift(r:PBIGNUM; a:PBIGNUM; n:cint; m:PBIGNUM; ctx:PBN_CTX):cint;
  function BN_mod_lshift_quick(r:PBIGNUM; a:PBIGNUM; n:cint; m:PBIGNUM):cint;
  function BN_mod_word(a:PBIGNUM; w:BN_ULONG):BN_ULONG;
  function BN_div_word(a:PBIGNUM; w:BN_ULONG):BN_ULONG;
  function BN_mul_word(a:PBIGNUM; w:BN_ULONG):cint;
  function BN_add_word(a:PBIGNUM; w:BN_ULONG):cint;
  function BN_sub_word(a:PBIGNUM; w:BN_ULONG):cint;
  function BN_set_word(a:PBIGNUM; w:BN_ULONG):cint;
  function BN_get_word(a:PBIGNUM):BN_ULONG;
  function BN_cmp(a:PBIGNUM; b:PBIGNUM):cint;
  procedure BN_free(a:PBIGNUM);

type
  POSSL_PROVIDER = SslPtr;
  POSSL_LIB_CTX = SslPtr;

  function OSSL_LIB_CTX_get0_global_default: POSSL_LIB_CTX;
  function OSSL_PROVIDER_available(libctx: POSSL_LIB_CTX; name: PAnsiChar): cint;
  function OSSL_PROVIDER_load(libctx: POSSL_LIB_CTX; name: PAnsiChar): POSSL_PROVIDER;
  function OSSL_PROVIDER_unload(prov: POSSL_PROVIDER): cint;
  function OSSL_PROVIDER_set_default_search_path(libctx: POSSL_LIB_CTX; const path: PAnsiChar): cint;


function IsSSLloaded: Boolean;
function InitSSLInterface: Boolean; overload;
function DestroySSLInterface: Boolean;

// compatibility with old versions.
function Islibealoaded: Boolean; deprecated;
function InitSSLInterface(AVerboseLoading: Boolean): Boolean ; overload; deprecated;
function InitSSLEAInterface(AVerboseLoading: Boolean): Boolean; deprecated;
function InitLibeaInterface(AVerboseLoading: Boolean = false): Boolean; deprecated;
function DestroySSLEAInterface: Boolean; deprecated;
function DestroyLibeaInterface: Boolean; deprecated;

function LibNumVersion: String;
function LibVersionIsGreaterThan1_0_0: Boolean;

var
  OpenSSL_unavailable_functions: string;

implementation

uses
  strutils
  {$IfDef ANDROID}
    {$IfNDef FPC}
      ,System.IOUtils
    {$EndIf}
  {$EndIf} ;

{
  Compatibility functions
}

Var
  SSLloaded: boolean = false;
  LoadVerbose : Boolean = true;
  SSLCS: TCriticalSection;
  Locks: Array of TCriticalSection;

resourcestring
  SFailedToLoadOpenSSL = 'Failed to load OpenSSL library';

function Islibealoaded: Boolean; deprecated;
begin
  Result:=isSSLLoaded;
end;

function InitSSLInterface(AVerboseLoading: Boolean): Boolean ; deprecated;

Var
  B : Boolean;

begin
  B:=LoadVerbose;
  LoadVerbose:=AVerboseLoading;
  try
    Result:=InitSSLInterface;
  finally
    LoadVerbose:=B;
  end;
end;

function InitSSLEAInterface(AVerboseLoading: Boolean): Boolean; deprecated;

Var
  B : Boolean;

begin
  B:=LoadVerbose;
  LoadVerbose:=AVerboseLoading;
  try
    Result:=InitSSLInterface;
  finally
    LoadVerbose:=B;
  end;
end;

function InitLibeaInterface(AVerboseLoading: Boolean = false): Boolean; deprecated;

Var
  B : Boolean;

begin
  B:=LoadVerbose;
  LoadVerbose:=AVerboseLoading;
  try
    Result:=InitSSLInterface;
  finally
    LoadVerbose:=B;
  end;
end;

function DestroySSLEAInterface: Boolean; deprecated;

begin
  Result:=DestroySSLInterface;
end;

function DestroyLibeaInterface: Boolean; deprecated;

begin
  Result:=DestroySSLInterface;
end;

function LibNumVersion: String;
begin
  Result := IntToHex(OpenSSLVersionNum, 9);
end;

function LibVersionIsGreaterThan1_0_0: Boolean;
var
  Major, Minor: Integer;
  s: String;
begin
  s := LibNumVersion;
  Major := StrToIntDef(copy(s, 1, 2), 0);
  Minor := StrToIntDef(copy(s, 3, 2), 0);
  Result :=  (Major > 1) or ((Major = 1) and (Minor > 0));
end;

type
// libssl.dll
  TOpenSSLVersion = function(arg : cint): PAnsiChar; cdecl;
  TOpenSSLVersionNum = function(): cLong; cdecl;
  TSslGetError = function(s: PSSL; ret_code: cInt):cInt; cdecl;
  TSslLibraryInit = function:cInt; cdecl;
  TSslLoadErrorStrings = procedure; cdecl;
  TSslCtxSetCipherList = function(arg0: PSSL_CTX; str: PAnsiChar):cInt; cdecl;
  TSslCtxNew = function(meth: PSSL_METHOD):PSSL_CTX; cdecl;
  TSslCtxFree = procedure(arg0: PSSL_CTX); cdecl;
  TSslSetFd = function(s: PSSL; fd: cInt):cInt; cdecl;
  TSslCtrl = function(ssl: PSSL; cmd: cInt; larg: clong; parg: Pointer): cLong; cdecl;
  TSslCTXCtrl = function(ctx: PSSL_CTX; cmd: cInt; larg: clong; parg: Pointer): cLong; cdecl;
  TSslCtxSetMinProtoVersion = function(ctx: PSSL_CTX; version: integer): integer; cdecl;
  TSslCtxSetMaxProtoVersion = function(ctx: PSSL_CTX; version: integer): integer; cdecl;
  TSslMethodV2 = function:PSSL_METHOD; cdecl;
  TSslMethodV3 = function:PSSL_METHOD; cdecl;
  TSslMethodTLSV1 = function:PSSL_METHOD; cdecl;
  TSslMethodTLSV1_1 = function:PSSL_METHOD; cdecl;
  TSslMethodTLSV1_2 = function:PSSL_METHOD; cdecl;
  TSslMethodV23 = function:PSSL_METHOD; cdecl;
  TSslTLSMethod = function:PSSL_METHOD; cdecl;
  TSslCtxUsePrivateKey = function(ctx: PSSL_CTX; pkey: sslptr):cInt; cdecl;
  TSslCtxUsePrivateKeyASN1 = function(pk: cInt; ctx: PSSL_CTX; d: sslptr; len: cInt):cInt; cdecl;
  TSslCtxUsePrivateKeyFile = function(ctx: PSSL_CTX; const _file: PAnsiChar; _type: cInt):cInt; cdecl;
  TSslCtxUseCertificate = function(ctx: PSSL_CTX; x: SslPtr):cInt; cdecl;
  TSslCtxUseCertificateASN1 = function(ctx: PSSL_CTX; len: cInt; d: SslPtr):cInt; cdecl;
  TSslCtxUseCertificateFile = function(ctx: PSSL_CTX; const _file: PAnsiChar; _type: cInt):cInt; cdecl;
  TSslCtxUseCertificateChainFile = function(ctx: PSSL_CTX; const _file: PAnsiChar):cInt; cdecl;
  TSslCtxCheckPrivateKeyFile = function(ctx: PSSL_CTX):cInt; cdecl;
  TSslCtxSetDefaultPasswdCb = procedure(ctx: PSSL_CTX; cb: SslPtr); cdecl;
  TSslCtxSetDefaultPasswdCbUserdata = procedure(ctx: PSSL_CTX; u: SslPtr); cdecl;
  TSslCtxLoadVerifyLocations = function(ctx: PSSL_CTX; const CAfile: PAnsiChar; const CApath: PAnsiChar):cInt; cdecl;
  TSslNew = function(ctx: PSSL_CTX):PSSL; cdecl;
  TSslFree = procedure(ssl: PSSL); cdecl;
  TSslAccept = function(ssl: PSSL):cInt; cdecl;
  TSslConnect = function(ssl: PSSL):cInt; cdecl;
  TSslShutdown = function(ssl: PSSL):cInt; cdecl;
  TSslRead = function(ssl: PSSL; buf: PAnsiChar; num: cInt):cInt; cdecl;
  TSslPeek = function(ssl: PSSL; buf: PAnsiChar; num: cInt):cInt; cdecl;
  TSslWrite = function(ssl: PSSL; const buf: PAnsiChar; num: cInt):cInt; cdecl;
  TSslPending = function(ssl: PSSL):cInt; cdecl;
  TSslGetVersion = function(ssl: PSSL):PAnsiChar; cdecl;
  TSslGetPeerCertificate = function(ssl: PSSL):PX509; cdecl;
  TSslCtxSetVerify = procedure(ctx: PSSL_CTX; mode: cInt; arg2: SslPtr); cdecl;
  TSSLGetCurrentCipher = function(s: PSSL):SslPtr; cdecl;
  TSSLCipherGetName = function(c: Sslptr):PAnsiChar; cdecl;
  TSSLCipherGetBits = function(c: SslPtr; alg_bits: PcInt):cInt; cdecl;
  TSSLGetVerifyResult = function(ssl: PSSL):cInt; cdecl;
  TSSLGetServername = function(ssl: PSSL; _type: cInt = TLSEXT_NAMETYPE_host_name): PAnsiChar; cdecl;
  TSSLCtxCallbackCtrl = procedure(ctx: PSSL_CTX; _type: cInt; cb: PCallbackCb); cdecl;
  TSSLSetSslCtx = function(ssl: PSSL; ctx: PSSL_CTX): PSSL; cdecl;

// libeay.dll
  TERR_load_crypto_strings = procedure; cdecl;
  TX509New = function: PX509; cdecl;
  TX509Free = procedure(x: PX509); cdecl;
  TX509_NAME_new = function: PX509_NAME; cdecl;
  TX509_NAME_free = procedure(a: PX509_NAME); cdecl;
  TX509NameOneline = function(a: PX509_NAME; buf: PAnsiChar; size: cInt):PAnsiChar; cdecl;
  TX509NAMEprintEx = function(b: PBIO; x: PX509_NAME; indent: cInt; flags: cuint):cInt; cdecl;
  TX509GetSubjectName = function(a: PX509):PX509_NAME; cdecl;
  TX509GetIssuerName = function(a: PX509):PX509_NAME; cdecl;
  TX509NameHash = function(x: PX509_NAME):cuLong; cdecl;
  TX509Digest = function(data: PX509; _type: PEVP_MD; md: PAnsiChar; len: PcInt):cInt; cdecl;
  TX509print = function(b: PBIO; a: PX509): cInt; cdecl;
  TX509SetVersion = function(x: PX509; version: cInt): cInt; cdecl;
  TX509SetPubkey = function(x: PX509; pkey: PEVP_PKEY): cInt; cdecl;
  TX509GetPubkey = function(x: PX509): PEVP_PKEY; cdecl;
  TX509SetIssuerName = function(x: PX509; name: PX509_NAME): cInt; cdecl;
  TX509NameAddEntryByTxt = function(name: PX509_NAME; field: PAnsiChar; _type: cInt;
    bytes: PAnsiChar; len, loc, _set: cInt): cInt; cdecl;
  TX509Sign = function(x: PX509; pkey: PEVP_PKEY; const md: PEVP_MD): cInt; cdecl;
  TX509GmtimeAdj = function(s: PASN1_UTCTIME; adj: cInt): PASN1_UTCTIME; cdecl;
  TX509GetNotBefore = function(x: PX509): pASN1_TIME; cdecl;
  TX509GetNotAfter = function(x: PX509): pASN1_TIME; cdecl;
  TX509SetNotBefore = function(x: PX509; tm: PASN1_UTCTIME): cInt; cdecl;
  TX509SetNotAfter = function(x: PX509; tm: PASN1_UTCTIME): cInt; cdecl;
  TX509GetSerialNumber = function(x: PX509): PASN1_cInt; cdecl;
  TX509GetExt = function(x: PX509; loc: integer): pX509_EXTENSION; cdecl;
  TX509ExtensionGetData = function (ext: pX509_EXTENSION): pASN1_STRING cdecl;
  TX509_REQ_new = function: PX509_REQ; cdecl;
  TX509_REQ_free = procedure(x: PX509_REQ); cdecl;
  TX509_REQ_set_subject_name = function(req: PX509_REQ; name: PX509_NAME): cInt; cdecl;
  TX509_REQ_set_pubkey = function (x: PX509_REQ; pkey: PEVP_PKEY): cInt; cdecl;
  TX509_REQ_sign = function(x: PX509_REQ; pkey: PEVP_PKEY; const md: PEVP_MD): cInt; cdecl;
  TEvpPkeyNew = function: PEVP_PKEY; cdecl;
  TEvpPkeyFree = procedure(pk: PEVP_PKEY); cdecl;
  TEvpPkeyAssign = function(pkey: PEVP_PKEY; _type: cInt; key: Prsa): cInt; cdecl;
  TEvpPkeyGet1RSA = function(key: PEVP_PKEY): pRSA; cdecl;
  TEvpPkeySet1RSA = function(pkey: PEVP_PKEY; rsa: pRSA): cInt; cdecl;
  TEvpGetDigestByName = function(Name: PAnsiChar): PEVP_MD; cdecl;
  TEVPcleanup = procedure; cdecl;
  TErrErrorString = procedure(e: cInt; buf: PAnsiChar; len: cInt); cdecl;
  TErrGetError = function: cInt; cdecl;
  TErrClearError = procedure; cdecl;
  TErrFreeStrings = procedure; cdecl;
  TErrRemoveState = procedure(pid: cInt); cdecl;
  TRandScreen = procedure; cdecl;
  TBioNew = function(b: PBIO_METHOD): PBIO; cdecl;
  TBioFreeAll = procedure(b: PBIO); cdecl;
  TBioSMem = function: PBIO_METHOD; cdecl;
  TBioCtrlPending = function(b: PBIO): cInt; cdecl;
  TBioRead = function(b: PBIO; Buf: PAnsiChar; Len: cInt): cInt; cdecl;
  TBioWrite = function(b: PBIO; Buf: PAnsiChar; Len: cInt): cInt; cdecl;
  TBioReset = function(b: pBIO): cint; cdecl;
  Td2iPKCS12bio = function(b:PBIO; Pkcs12: SslPtr): SslPtr; cdecl;
  TPKCS12parse = function(p12: SslPtr; pass: PAnsiChar; var pkey: pEVP_PKEY;
    var cert: pX509; var ca: SslPtr): cInt; cdecl;
  TPKCS12free = procedure(p12: SslPtr); cdecl;
  TAsn1StringTypeNew = function(aype : cint): SSlPtr; cdecl;
  TAsn1UtcTimeSetString = function(t : PASN1_UTCTIME; S : PAnsiChar): cint; cdecl;
  TAsn1UtctimePrint = Function(b : PBio;a: PASN1_UTCTIME) : cint; cdecl;
  TAsn1UtctimeFree = procedure(a: PASN1_UTCTIME); cdecl;
  TAsn1IntegerSet = function(a: PASN1_INTEGER; v: integer): integer; cdecl;
  TAsn1IntegerGet = function(a: PASN1_INTEGER): integer; cdecl;
  Ti2dX509bio = function(b: PBIO; x: PX509): cInt; cdecl;
  Td2iX509bio = function(b: pBIO; x: PX509): PX509; cdecl;
  Ti2dPrivateKeyBio= function(b: PBIO; pkey: PEVP_PKEY): cInt; cdecl;
  TOPENSSL_sk_new_null =  function: PSTACK; cdecl;
  TOPENSSL_sk_num = function(Stack: PSTACK): Integer; cdecl;
  TOPENSSL_sk_value = function(Stack: PSTACK; Item: Integer): PAnsiChar; cdecl;
  TOPENSSL_sk_free = procedure(Stack: PSTACK); cdecl;
  TOPENSSL_sk_pop_free = procedure(Stack: PSTACK; func: Tsk_pop_free_func); cdecl;
  TOPENSSL_sk_insert = function(Stack: PSTACK; Data: PAnsiChar; Index: Integer): Integer; cdecl;
  TX509_dup = function(X: PX509): PX509; cdecl;
  TSSL_CTX_get_cert_store =  function(const Ctx: PSSL_CTX): PX509_STORE;cdecl;
  TX509_STORE_add_cert = function(Store: PX509_STORE; Cert: PX509): Integer; cdecl;

  // 3DES functions
  TDESsetoddparity = procedure(Key: des_cblock); cdecl;
  TDESsetkeychecked = function(key: des_cblock; schedule: des_key_schedule): cInt; cdecl;
  TDESsetkey = TDESsetkeychecked;
  TDESecbencrypt = procedure(Input: des_cblock; output: des_cblock; ks: des_key_schedule; enc: cInt); cdecl;
  //thread lock functions
  TCRYPTOnumlocks = function: cInt; cdecl;
  TCRYPTOSetLockingCallback = procedure(cb: Sslptr); cdecl;

  // RAND functions
  TRAND_set_rand_method = function(const meth: PRAND_METHOD): cint; cdecl;
  TRAND_get_rand_method = function(): PRAND_METHOD; cdecl;
  TRAND_SSLeay = function(): PRAND_METHOD; cdecl;
  TRAND_cleanup = procedure(); cdecl;
  TRAND_bytes = function(buf: PByte; num: cint): cint; cdecl;
  TRAND_pseudo_bytes = function(buf: PByte; num: cint): cint; cdecl;
  TRAND_seed = procedure(const buf: Pointer; num: cint); cdecl;
  TRAND_add = procedure(const buf: Pointer; num: cint; entropy: cdouble); cdecl;
  TRAND_load_file = function(const file_name: PAnsiChar; max_bytes: clong): cint; cdecl;
  TRAND_write_file = function(const file_name: PAnsiChar): cint; cdecl;
  TRAND_file_name = function(file_name: PAnsiChar; num: csize_t): PAnsiChar; cdecl;
  TRAND_status = function(): cint; cdecl;
  TRAND_query_egd_bytes = function(const path: PAnsiChar; buf: PByte; bytes: cint): cint; cdecl;
  TRAND_egd = function(const path: PAnsiChar): cint; cdecl;
  TRAND_egd_bytes = function(const path: PAnsiChar; bytes: cint): cint; cdecl;
  TERR_load_RAND_strings = procedure(); cdecl;
  TRAND_poll = function(): cint; cdecl;

  // RSA Functions
  TRSA_new = function (): PRSA; cdecl;
  TRSA_new_method = function (method: PENGINE): PRSA; cdecl;
  TRSA_size = function (arsa: PRSA): cint; cdecl;
  TRsaGenerateKey = function(bits, e: cInt; callback: PFunction; cb_arg: SslPtr): PRSA; cdecl;
  TRSA_generate_key_ex = function (arsa: PRSA; bits: cInt; e: PBIGNUM; cb: PBN_GENCB): cint; cdecl;
  TRSA_check_key = function (arsa: PRSA): cint; cdecl;
  TRSA_public_encrypt = function (flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_private_encrypt = function (flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_public_decrypt = function (flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_private_decrypt = function (flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint; cdecl;
  TRSA_free = procedure (arsa: PRSA); cdecl;
  TRSA_flags = function (arsa: PRSA): Integer; cdecl;
  TRSA_set_default_method = procedure (method: PRSA_METHOD); cdecl;
  TRSA_get_default_method = function : PRSA_METHOD; cdecl;
  TRSA_get_method = function (prsa: PRSA): PRSA_METHOD; cdecl;
  TRSA_set_method = function (arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD; cdecl;
  TRSA_get0_n = function (const d :PRSA) :PBIGNUM; cdecl;
  TRSA_get0_e = function (const d :PRSA) :PBIGNUM; cdecl;
  TRSA_get0_d = function (const d :PRSA) :PBIGNUM; cdecl;
  TRSA_get0_p = function (const d :PRSA) :PBIGNUM; cdecl;
  TRSA_get0_q = function (const d :PRSA) :PBIGNUM; cdecl;
  TRSA_set0_key = function (r: pRSA; n: PBIGNUM; e: PBIGNUM; d: PBIGNUM): cint; cdecl;

  TRSA_get_version = function (r :PRSA) :cint; cdecl;
  TRSA_pkey_ctx_ctrl = function(ctx: PEVP_PKEY_CTX; optype: cint; cmd: cint; p1: cint; p2: Pointer): cint; cdecl;

  // X509 Functions
  Td2i_RSAPublicKey = function (arsa: PPRSA; pp: PPByte; len: cint): PRSA; cdecl;
  Ti2d_RSAPublicKey = function (arsa: PRSA; pp: PPByte): cint; cdecl;
  Td2i_RSAPrivateKey = function (arsa: PPRSA; pp: PPByte; len: cint): PRSA; cdecl;
  Ti2d_RSAPrivateKey = function (arsa: PRSA; pp: PPByte): cint; cdecl;
  Td2i_Key = function (a: PPEVP_PKEY; pp: PPByte; len: clong): PEVP_PKEY; cdecl;

  // ERR Functions
  TErr_Error_String = function (e: cInt; buf: PAnsiChar): PAnsiChar; cdecl;

  // Crypto Functions
  TCRYPTOcleanupAllExData = procedure; cdecl;
  TOPENSSLaddallalgorithms = procedure; cdecl;

  // EVP Functions
  TOpenSSL_add_all_algorithms = procedure(); cdecl;
  TOpenSSL_add_all_ciphers = procedure(); cdecl;
  TOpenSSL_add_all_digests = procedure(); cdecl;
  //
  TEVP_DigestInit = function(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint; cdecl;
  TEVP_DigestUpdate = function(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint; cdecl;
  TEVP_DigestFinal = function(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint; cdecl;

  TEVP_SignFinal = function(ctx: pEVP_MD_CTX; sig: pointer; var s: cardinal;
    key: pEVP_PKEY): integer; cdecl;
  TEVP_PKEY_size = function(key: pEVP_PKEY): integer; cdecl;
  TEVP_PKEY_free = Procedure(key: pEVP_PKEY); cdecl;
  TEVP_PKEY_new_mac_key = function(type_: cint; e: PENGINE; key: PByte; keylen :cint): PEVP_PKEY;  // Tz HMAC
  TEVP_VerifyFinal = function(ctx: pEVP_MD_CTX; sigbuf: pointer;
    siglen: cardinal; pkey: pEVP_PKEY): integer;  cdecl;
  //
  TEVP_CIPHERFunction = function() : PEVP_CIPHER; cdecl;
  TEVP_get_cipherbyname = function(const name: PAnsiChar): PEVP_CIPHER; cdecl;
  TEVP_get_digestbyname = function(const name: PAnsiChar): PEVP_MD; cdecl;
  //
  TEVP_CIPHER_CTX_init = procedure(a: PEVP_CIPHER_CTX); cdecl;
  TEVP_CIPHER_CTX_cleanup = function(a: PEVP_CIPHER_CTX): cint; cdecl;
  TEVP_CIPHER_CTX_new = function :PEVP_CIPHER_CTX; cdecl;            // Tz Cipher
  TEVP_CIPHER_CTX_free = procedure(ctx :PEVP_CIPHER_CTX); cdecl ;      // Tz Cipher
  TEVP_CIPHER_CTX_set_key_length = function(x: PEVP_CIPHER_CTX; keylen: cint): cint; cdecl;
  TEVP_CIPHER_CTX_ctrl = function(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint; cdecl;
  //
  TEVP_EncryptInit = function(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER;
           const key, iv: PByte): cint; cdecl;
  TEVP_EncryptUpdate = function(ctx: PEVP_CIPHER_CTX; out_: pcuchar;
           outlen: pcint; const in_: pcuchar; inlen: cint): cint; cdecl;
  TEVP_EncryptFinal = function(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint; cdecl;
  //
  TEVP_DecryptInit = function(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER;
           const key, iv: PByte): cint; cdecl;
  TEVP_DecryptUpdate = function(ctx: PEVP_CIPHER_CTX; out_data: PByte;
           outl: pcint; const in_: PByte; inl: cint): cint; cdecl;
  TEVP_DecryptFinal = function(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint; cdecl;
  //
  TEVP_MD_CTX_new = function(): PEVP_MD_CTX; cdecl;
  TEVP_MD_CTX_free = procedure(ctx: PEVP_MD_CTX); cdecl;

  TEVP_PKEY_CTX_new = function(pkey: PEVP_PKEY; e: PENGINE): PEVP_PKEY_CTX; cdecl;
  TEVP_PKEY_CTX_free = procedure(ctx: PEVP_PKEY_CTX); cdecl;
  TEVP_PKEY_CTX_ctrl = function(ctx: PEVP_PKEY_CTX; keytype: cint; optype: cint; cmd: cint; p1: cint; p2: Pointer): cint; cdecl;
  TEVP_PKEY_encrypt_init = function(ctx: PEVP_PKEY_CTX): cint; cdecl;
  TEVP_PKEY_encrypt = function(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint; const in_data: PByte; inlen: csize_t): cint; cdecl;
  TEVP_PKEY_decrypt_init = function(ctx: PEVP_PKEY_CTX): cint; cdecl;
  TEVP_PKEY_decrypt = function(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint; const in_data: PByte; inlen: csize_t): cint; cdecl;

  TEVP_DigestSignVerifyInit = function(ctx: PEVP_MD_CTX; pctx: PPEVP_PKEY_CTX; const evptype: PEVP_MD; e: PENGINE; pkey: PEVP_PKEY): cint;
  TEVP_DigestSignFinal = function(ctx: PEVP_MD_CTX; sigret: PByte; siglen: pcsize_t): cint;
  TEVP_DigestVerifyFinal = function(ctx: PEVP_MD_CTX; sig: PByte; siglen: csize_t): cint;
  // PEM functions

  TPEM_read_bio_PrivateKey = function(bp: PBIO; X: PPEVP_PKEY;
           cb: Ppem_password_cb; u: Pointer): PEVP_PKEY; cdecl;

  TPEM_read_bio_PUBKEY = function(bp: pBIO; var x: pEVP_PKEY;
               cb: Ppem_password_cb; u: pointer): pEVP_PKEY; cdecl;
  TPEM_write_bio_PrivateKey = function(bp: pBIO; x: pEVP_PKEY;
               const enc: pEVP_CIPHER; kstr: PAnsiChar; klen: Integer; cb: Ppem_password_cb;
               u: pointer): integer; cdecl;
  TPEM_write_bio_PUBKEY = function(bp: pBIO; x: pEVP_PKEY): integer; cdecl;
  TPEM_read_bio_X509 = function(bp: pBIO; x: PPX509; cb: Ppem_password_cb; u: pointer): px509; cdecl;
  TPEM_write_bio_X509 = function(bp: pBIO; x: PX509): integer; cdecl;
  TPEM_write_bio_X509_REQ = function(bp: pBIO;  x: PX509_REQ): integer; cdecl;

  TPEM_write_bio_PKCS7 = function(bp: pBIO; x: PPKCS7): integer; cdecl;
  TPEM_read_bio_RSAPrivateKey = function(bp: pBIO; var x: pRSA;
      cb: Ppem_password_cb; u: pointer): pRSA; cdecl;
  TPEM_write_bio_RSAPrivateKey = function(bp: pBIO; x: pRSA; const enc: pEVP_CIPHER;
      kstr: PAnsiChar; klen: integer; cb: Ppem_password_cb;
      u: pointer): integer; cdecl;
  TPEM_read_bio_RSAPublicKey = function(bp: pBIO; var x: pRSA;
      cb: Ppem_password_cb; u: pointer): pRSA; cdecl;
  TPEM_write_bio_RSAPublicKey = function (bp: pBIO; x: pRSA): integer; cdecl;

  // BIO Functions

  TBIO_ctrl = function(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong; cdecl;

  TBIO_s_file = function: pBIO_METHOD; cdecl;
  TBIO_new_file = function(const filename: PAnsiChar; const mode: PAnsiChar): pBIO; cdecl;
  TBIO_new_mem_buf = function(buf: pointer; len: integer): pBIO; cdecl;

var
// libssl.dll
  _OpenSSLVersion : TOpenSSLVersion = Nil;
  _OpenSSLVersionNum : TOpenSSLVersionNum = Nil;
  _SslGetError: TSslGetError = nil;
  _SslLibraryInit: TSslLibraryInit = nil;
  _SslLoadErrorStrings: TSslLoadErrorStrings = nil;
  _SslCtxSetCipherList: TSslCtxSetCipherList = nil;
  _SslCtxNew: TSslCtxNew = nil;
  _SslCtxFree: TSslCtxFree = nil;
  _SslSetFd: TSslSetFd = nil;
  _SslCtrl: TSslCtrl = nil;
  _SslCTXCtrl: TSslCTXCtrl = nil;
  _SslCtxSetMinProtoVersion: TSslCtxSetMinProtoVersion = nil;
  _SslCtxSetMaxProtoVersion: TSslCtxSetMaxProtoVersion = nil;
  _SslMethodV2: TSslMethodV2 = nil;
  _SslMethodV3: TSslMethodV3 = nil;
  _SslMethodTLSV1: TSslMethodTLSV1 = nil;
  _SslMethodTLSV1_1: TSslMethodTLSV1_1 = nil;
  _SslMethodTLSV1_2: TSslMethodTLSV1_2 = nil;
  _SslMethodV23: TSslMethodV23 = nil;
  _SslTLSMethod: TSslTLSMethod = nil;
  _SslCtxUsePrivateKey: TSslCtxUsePrivateKey = nil;
  _SslCtxUsePrivateKeyASN1: TSslCtxUsePrivateKeyASN1 = nil;
  _SslCtxUsePrivateKeyFile: TSslCtxUsePrivateKeyFile = nil;
  _SslCtxUseCertificate: TSslCtxUseCertificate = nil;
  _SslCtxUseCertificateASN1: TSslCtxUseCertificateASN1 = nil;
  _SslCtxUseCertificateFile: TSslCtxUseCertificateFile = nil;
  _SslCtxUseCertificateChainFile: TSslCtxUseCertificateChainFile = nil;
  _SslCtxCheckPrivateKeyFile: TSslCtxCheckPrivateKeyFile = nil;
  _SslCtxSetDefaultPasswdCb: TSslCtxSetDefaultPasswdCb = nil;
  _SslCtxSetDefaultPasswdCbUserdata: TSslCtxSetDefaultPasswdCbUserdata = nil;
  _SslCtxLoadVerifyLocations: TSslCtxLoadVerifyLocations = nil;
  _SslNew: TSslNew = nil;
  _SslFree: TSslFree = nil;
  _SslAccept: TSslAccept = nil;
  _SslConnect: TSslConnect = nil;
  _SslShutdown: TSslShutdown = nil;
  _SslRead: TSslRead = nil;
  _SslPeek: TSslPeek = nil;
  _SslWrite: TSslWrite = nil;
  _SslPending: TSslPending = nil;
  _SslGetVersion: TSslGetVersion = nil;
  _SslGetPeerCertificate: TSslGetPeerCertificate = nil;
  _SslCtxSetVerify: TSslCtxSetVerify = nil;
  _SSLGetCurrentCipher: TSSLGetCurrentCipher = nil;
  _SSLCipherGetName: TSSLCipherGetName = nil;
  _SSLCipherGetBits: TSSLCipherGetBits = nil;
  _SSLGetVerifyResult: TSSLGetVerifyResult = nil;
  _SSLGetServername: TSSLGetServername = nil;
  _SslCtxCallbackCtrl: TSSLCtxCallbackCtrl = nil;
  _SslSetSslCtx: TSSLSetSslCtx = nil;

// libeay.dll
  _ERR_load_crypto_strings: TERR_load_crypto_strings = nil;
  _X509New: TX509New = nil;
  _X509Free: TX509Free = nil;
  _X509_NAME_new: TX509_NAME_new = nil;
  _X509_NAME_free: TX509_NAME_free = nil;
  _X509NameOneline: TX509NameOneline = nil;
  _X509NAMEprintEx: TX509NAMEprintEx = nil;
  _X509GetSubjectName: TX509GetSubjectName = nil;
  _X509GetIssuerName: TX509GetIssuerName = nil;
  _X509NameHash: TX509NameHash = nil;
  _X509Digest: TX509Digest = nil;
  _X509print: TX509print = nil;
  _X509SetVersion: TX509SetVersion = nil;
  _X509SetPubkey: TX509SetPubkey = nil;
  _X509GetPubkey: TX509GetPubkey = nil;
  _X509SetIssuerName: TX509SetIssuerName = nil;
  _X509NameAddEntryByTxt: TX509NameAddEntryByTxt = nil;
  _X509Sign: TX509Sign = nil;
  _X509GmtimeAdj: TX509GmtimeAdj = nil;
  _X509GetNotBefore: TX509GetNotBefore = nil;
  _X509GetNotAfter: TX509GetNotAfter = nil;
  _X509SetNotBefore: TX509SetNotBefore = nil;
  _X509SetNotAfter: TX509SetNotAfter = nil;
  _X509GetSerialNumber: TX509GetSerialNumber = nil;
  _X509GetExt: TX509GetExt = nil;
  _X509ExtensionGetData: TX509ExtensionGetData = nil;
  _X509_REQ_new: TX509_REQ_new = nil;
  _X509_REQ_free: TX509_REQ_free = nil;
  _X509_REQ_set_subject_name: TX509_REQ_set_subject_name = nil;
  _X509_REQ_set_pubkey: TX509_REQ_set_pubkey = nil;
  _X509_REQ_sign: TX509_REQ_sign = nil;
  _EvpPkeyNew: TEvpPkeyNew = nil;
  _EvpPkeyFree: TEvpPkeyFree = nil;
  _EvpPkeyAssign: TEvpPkeyAssign = nil;
  _EvpPkeySet1RSA: TEvpPkeySet1RSA = nil;
  _EvpPkeyGet1RSA: TEvpPkeyGet1RSA = nil;
  _EvpGetDigestByName: TEvpGetDigestByName = nil;
  _EVPcleanup: TEVPcleanup = nil;
  _ErrErrorString: TErrErrorString = nil;
  _ErrGetError: TErrGetError = nil;
  _ErrClearError: TErrClearError = nil;
  _ErrFreeStrings: TErrFreeStrings = nil;
  _ErrRemoveState: TErrRemoveState = nil;
  _RandScreen: TRandScreen = nil;
  _BioNew: TBioNew = nil;
  _BioFreeAll: TBioFreeAll = nil;
  _BioSMem: TBioSMem = nil;
  _BioCtrlPending: TBioCtrlPending = nil;
  _BioRead: TBioRead = nil;
  _BioWrite: TBioWrite = nil;
  _BioReset: TBioReset = nil;
  _d2iPKCS12bio: Td2iPKCS12bio = nil;
  _PKCS12parse: TPKCS12parse = nil;
  _PKCS12free: TPKCS12free = nil;
  _Asn1StringTypeNew: TAsn1StringTypeNew = nil;
  _Asn1UtctimeSetString : TAsn1UtctimeSetString = Nil;
  _Asn1UtctimePrint: TAsn1UtctimePrint = nil;
  _Asn1UtctimeFree: TAsn1UtctimeFree = nil;
  _Asn1IntegerSet: TAsn1IntegerSet = nil;
  _Asn1IntegerGet: TAsn1IntegerGet = nil;
  _i2dX509bio: Ti2dX509bio = nil;
  _d2iX509bio: Td2iX509bio = nil;
  _i2dPrivateKeyBio: Ti2dPrivateKeyBio = nil;
  _OPENSSL_sk_new_null: TOPENSSL_sk_new_null  = nil;
  _OPENSSL_sk_num: TOPENSSL_sk_num  = nil;
  _OPENSSL_sk_value: TOPENSSL_sk_value  = nil;
  _OPENSSL_sk_pop_free: TOPENSSL_sk_pop_free = nil;
  _OPENSSL_sk_free: TOPENSSL_sk_free   = nil;
  _OPENSSL_sk_insert: TOPENSSL_sk_insert = nil;
  _SSL_CTX_get_cert_store : TSSL_CTX_get_cert_store = nil;
  _X509_STORE_add_cert : TX509_STORE_add_cert = nil;

  _EVP_enc_null : TEVP_CIPHERFunction = nil;
  _EVP_rc2_cbc : TEVP_CIPHERFunction = nil;
  _EVP_rc2_40_cbc : TEVP_CIPHERFunction = nil;
  _EVP_rc2_64_cbc : TEVP_CIPHERFunction = nil;
  _EVP_rc4 : TEVP_CIPHERFunction = nil;
  _EVP_rc4_40 : TEVP_CIPHERFunction = nil;
  _EVP_des_cbc : TEVP_CIPHERFunction = nil;
  _EVP_des_ede3_cbc : TEVP_CIPHERFunction = nil;
  _EVP_aes_128_cbc : TEVP_CIPHERFunction = nil;
  _EVP_aes_192_cbc : TEVP_CIPHERFunction = nil;
  _EVP_aes_256_cbc : TEVP_CIPHERFunction = nil;
  _EVP_aes_128_cfb8 : TEVP_CIPHERFunction = nil;
  _EVP_aes_192_cfb8 : TEVP_CIPHERFunction = nil;
  _EVP_aes_256_cfb8 : TEVP_CIPHERFunction = nil;
  _EVP_camellia_128_cbc : TEVP_CIPHERFunction = nil;
  _EVP_camellia_192_cbc : TEVP_CIPHERFunction = nil;
  _EVP_camellia_256_cbc : TEVP_CIPHERFunction = nil;
  _EVP_sha256 : TEVP_CIPHERFunction = nil;

  // 3DES functions
  _DESsetoddparity: TDESsetoddparity = nil;
  _DESsetkey     : TDESsetkey = nil;
  _DESsetkeychecked: TDESsetkeychecked = nil;
  _DESecbencrypt: TDESecbencrypt = nil;
  //thread lock functions
  _CRYPTOnumlocks: TCRYPTOnumlocks = nil;
  _CRYPTOSetLockingCallback: TCRYPTOSetLockingCallback = nil;

  // RAND functions
  _RAND_set_rand_method: TRAND_set_rand_method = nil;
  _RAND_get_rand_method: TRAND_get_rand_method = nil;
  _RAND_SSLeay: TRAND_SSLeay = nil;
  _RAND_cleanup: TRAND_cleanup = nil;
  _RAND_bytes: TRAND_bytes = nil;
  _RAND_pseudo_bytes: TRAND_pseudo_bytes = nil;
  _RAND_seed: TRAND_seed = nil;
  _RAND_add: TRAND_add = nil;
  _RAND_load_file: TRAND_load_file = nil;
  _RAND_write_file: TRAND_write_file = nil;
  _RAND_file_name: TRAND_file_name = nil;
  _RAND_status: TRAND_status = nil;
  _RAND_query_egd_bytes: TRAND_query_egd_bytes = nil;
  _RAND_egd: TRAND_egd = nil;
  _RAND_egd_bytes: TRAND_egd_bytes = nil;
  _ERR_load_RAND_strings: TERR_load_RAND_strings = nil;
  _RAND_poll: TRAND_poll = nil;

  // RSA Functions
  _RSA_new: TRSA_new = nil;
  _RSA_new_method: TRSA_new_method = nil;
  _RSA_size: TRSA_size = nil;
  _RsaGenerateKey: TRsaGenerateKey = nil;
  _RSA_generate_key_ex: TRSA_generate_key_ex = nil;
  _RSA_check_key: TRSA_check_key = nil;
  _RSA_public_encrypt: TRSA_public_encrypt = nil;
  _RSA_private_encrypt: TRSA_private_encrypt = nil;
  _RSA_public_decrypt: TRSA_public_decrypt = nil;
  _RSA_private_decrypt: TRSA_private_decrypt = nil;
  _RSA_free: TRSA_free = nil;
  _RSA_flags: TRSA_flags = nil;
  _RSA_set_default_method: TRSA_set_default_method = nil;
  _RSA_get_default_method: TRSA_get_default_method = nil;
  _RSA_get_method: TRSA_get_method = nil;
  _RSA_set_method: TRSA_set_method = nil;
  _RSA_get0_n: TRSA_get0_n = nil;
  _RSA_get0_e: TRSA_get0_e = nil;
  _RSA_get0_d: TRSA_get0_d = nil;
  _RSA_get0_p: TRSA_get0_p = nil;
  _RSA_get0_q: TRSA_get0_q = nil;
  _RSA_set0_key: TRSA_set0_key = nil;

  _RSA_get_version: TRSA_get_version = nil;
  _RSA_pkey_ctx_ctrl: TRSA_pkey_ctx_ctrl = nil;

  // X509 Functions
  _d2i_RSAPublicKey: Td2i_RSAPublicKey = nil;
  _i2d_RSAPublicKey: Ti2d_RSAPublicKey = nil;
  _d2i_RSAPrivateKey: Td2i_RSAPrivateKey = nil;
  _i2d_RSAPrivateKey: Ti2d_RSAPrivateKey = nil;
  _d2i_PubKey: Td2i_Key = nil;
  _d2i_AutoPrivateKey: Td2i_Key = nil;
  // ERR Functions
  _Err_Error_String: TErr_Error_String = nil;

  // Crypto Functions
  _CRYPTOcleanupAllExData: TCRYPTOcleanupAllExData = nil;
  _OPENSSLaddallalgorithms: TOPENSSLaddallalgorithms = nil;

  // EVP Functions
  _OpenSSL_add_all_algorithms: TOpenSSL_add_all_algorithms = nil;
  _OpenSSL_add_all_ciphers: TOpenSSL_add_all_ciphers = nil;
  _OpenSSL_add_all_digests: TOpenSSL_add_all_digests = nil;
  //
  _EVP_DigestInit: TEVP_DigestInit = nil;
  _EVP_DigestUpdate: TEVP_DigestUpdate = nil;
  _EVP_DigestFinal: TEVP_DigestFinal = nil;

  _EVP_SignFinal: TEVP_SignFinal = nil;
  _EVP_PKEY_size: TEVP_PKEY_size = nil;
  _EVP_PKEY_free: TEVP_PKEY_free = nil;
  _EVP_PKEY_new_mac_key: TEVP_PKEY_new_mac_key = nil; // Tz HMAC
  _EVP_VerifyFinal: TEVP_VerifyFinal = nil;
  //
  _EVP_get_cipherbyname: TEVP_get_cipherbyname = nil;
  _EVP_get_digestbyname: TEVP_get_digestbyname = nil;
  //
  _EVP_CIPHER_CTX_init: TEVP_CIPHER_CTX_init = nil;
  _EVP_CIPHER_CTX_cleanup: TEVP_CIPHER_CTX_cleanup = nil;
  _EVP_CIPHER_CTX_new: TEVP_CIPHER_CTX_new = nil;
  _EVP_CIPHER_CTX_free: TEVP_CIPHER_CTX_free = nil;
  _EVP_CIPHER_CTX_set_key_length: TEVP_CIPHER_CTX_set_key_length = nil;
  _EVP_CIPHER_CTX_ctrl: TEVP_CIPHER_CTX_ctrl = nil;
  //
  _EVP_EncryptInit: TEVP_EncryptInit = nil;
  _EVP_EncryptUpdate: TEVP_EncryptUpdate = nil;
  _EVP_EncryptFinal: TEVP_EncryptFinal = nil;
  //
  _EVP_DecryptInit: TEVP_DecryptInit = nil;
  _EVP_DecryptUpdate: TEVP_DecryptUpdate = nil;
  _EVP_DecryptFinal: TEVP_DecryptFinal = nil;
  //
  _EVP_MD_CTX_new : TEVP_MD_CTX_new = nil;
  _EVP_MD_CTX_free : TEVP_MD_CTX_free = nil;

  _EVP_PKEY_CTX_new: TEVP_PKEY_CTX_new = nil;
  _EVP_PKEY_CTX_free: TEVP_PKEY_CTX_free = nil;
  _EVP_PKEY_CTX_ctrl: TEVP_PKEY_CTX_ctrl = nil;
  _EVP_PKEY_encrypt_init: TEVP_PKEY_encrypt_init = nil;
  _EVP_PKEY_encrypt: TEVP_PKEY_encrypt = nil;
  _EVP_PKEY_decrypt_init: TEVP_PKEY_decrypt_init = nil;
  _EVP_PKEY_decrypt: TEVP_PKEY_decrypt = nil;

  _EVP_DigestSignInit: TEVP_DigestSignVerifyInit = nil;
  _EVP_DigestSignFinal: TEVP_DigestSignFinal = nil;
  _EVP_DigestVerifyInit: TEVP_DigestSignVerifyInit = nil;
  _EVP_DigestVerifyFinal: TEVP_DigestVerifyFinal = nil;
  // PEM
  _PEM_read_bio_PrivateKey: TPEM_read_bio_PrivateKey = nil;
  _PEM_read_bio_PUBKEY: TPEM_read_bio_PUBKEY = nil;
  _PEM_write_bio_PrivateKey: TPEM_write_bio_PrivateKey = nil;
  _PEM_write_bio_PUBKEY: TPEM_write_bio_PUBKEY = nil;
  _PEM_read_bio_X509: TPEM_read_bio_X509 = nil;
  _PEM_write_bio_X509: TPEM_write_bio_X509 = nil;
  _PEM_write_bio_X509_REQ: TPEM_write_bio_X509_REQ = nil;
  _PEM_write_bio_PKCS7 : TPEM_write_bio_PKCS7 = nil;
  _PEM_read_bio_RSAPrivateKey: TPEM_read_bio_RSAPrivateKey = nil;
  _PEM_write_bio_RSAPrivateKey: TPEM_write_bio_RSAPrivateKey = nil;
  _PEM_read_bio_RSAPublicKey: TPEM_read_bio_RSAPublicKey = nil;
  _PEM_write_bio_RSAPublicKey: TPEM_write_bio_RSAPublicKey = nil;

  // BIO Functions
  _BIO_ctrl: TBIO_ctrl = nil;

  _BIO_s_file: TBIO_s_file = nil;
  _BIO_new_file: TBIO_new_file = nil;
  _BIO_new_mem_buf: TBIO_new_mem_buf = nil;

  //  PKCS7 functions
{  PKCS7_ISSUER_AND_SERIAL_it : ASN1_ITEM;cvar;external;
  PKCS7_SIGNER_INFO_it : ASN1_ITEM;cvar;external;
  PKCS7_RECIP_INFO_it : ASN1_ITEM;cvar;external;
  PKCS7_SIGNED_it : ASN1_ITEM;cvar;external;
  PKCS7_ENC_CONTENT_it : ASN1_ITEM;cvar;external;
  PKCS7_ENVELOPE_it : ASN1_ITEM;cvar;external;
  PKCS7_SIGN_ENVELOPE_it : ASN1_ITEM;cvar;external;
  PKCS7_DIGEST_it : ASN1_ITEM;cvar;external;
  PKCS7_ENCRYPT_it : ASN1_ITEM;cvar;external;
  PKCS7_it : ASN1_ITEM;cvar;external;
  PKCS7_ATTR_SIGN_it : ASN1_ITEM;cvar;external;
  PKCS7_ATTR_VERIFY_it : ASN1_ITEM;cvar;external;
}
  _PKCS7_ISSUER_AND_SERIAL_new : function: PPKCS7_ISSUER_AND_SERIAL;cdecl;
  _PKCS7_ISSUER_AND_SERIAL_free : procedure(a:PPKCS7_ISSUER_AND_SERIAL);cdecl;
  _PKCS7_ISSUER_AND_SERIAL_digest : function(data:PPKCS7_ISSUER_AND_SERIAL; _type:PEVP_MD; md:Pbyte; len:Pdword):longint;cdecl;
  _PKCS7_dup : function(p7:PPKCS7):PPKCS7;cdecl;
  _PEM_write_bio_PKCS7_stream : function(_out:PBIO; p7:PPKCS7; _in:PBIO; flags:longint):longint;cdecl;
  _PKCS7_SIGNER_INFO_new : function:PPKCS7_SIGNER_INFO;cdecl;
  _PKCS7_SIGNER_INFO_free : procedure(a:PPKCS7_SIGNER_INFO);cdecl;
  _PKCS7_RECIP_INFO_new : function:PPKCS7_RECIP_INFO;cdecl;
  _PKCS7_RECIP_INFO_free : procedure(a:PPKCS7_RECIP_INFO);cdecl;
  _PKCS7_SIGNED_new : function:PPKCS7_SIGNED;cdecl;
  _PKCS7_SIGNED_free : procedure(a:PPKCS7_SIGNED);cdecl;
  _PKCS7_ENC_CONTENT_new : function:PPKCS7_ENC_CONTENT;cdecl;
  _PKCS7_ENC_CONTENT_free : procedure(a:PPKCS7_ENC_CONTENT);cdecl;
  _PKCS7_ENVELOPE_new : function:PPKCS7_ENVELOPE;cdecl;
  _PKCS7_ENVELOPE_free : procedure(a:PPKCS7_ENVELOPE);cdecl;
  _PKCS7_SIGN_ENVELOPE_new : function:PPKCS7_SIGN_ENVELOPE;cdecl;
  _PKCS7_SIGN_ENVELOPE_free : procedure(a:PPKCS7_SIGN_ENVELOPE);cdecl;
  _PKCS7_DIGEST_new : function:PPKCS7_DIGEST;cdecl;
  _PKCS7_DIGEST_free : procedure(a:PPKCS7_DIGEST);cdecl;
  _PKCS7_ENCRYPT_new : function:PPKCS7_ENCRYPT;cdecl;
  _PKCS7_ENCRYPT_free : procedure(a:PPKCS7_ENCRYPT);cdecl;
  _PKCS7_new : function:PPKCS7;cdecl;
  _PKCS7_free : procedure(a:PPKCS7);cdecl;
  _PKCS7_print_ctx : function(_out:PBIO; x:PPKCS7; indent:longint; pctx:Pointer):longint;cdecl;
  _PKCS7_ctrl : function(p7:PPKCS7; cmd:longint; larg:longint; parg:PAnsiChar):longint;cdecl;
  _PKCS7_set_type : function(p7:PPKCS7; _type:longint):longint;cdecl;
  _PKCS7_set0_type_other : function(p7:PPKCS7; _type:longint; other:PASN1_TYPE):longint;cdecl;
  _PKCS7_set_content : function(p7:PPKCS7; p7_data:PPKCS7):longint;cdecl;
  _PKCS7_SIGNER_INFO_set : function(p7i:PPKCS7_SIGNER_INFO; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):longint;cdecl;
  _PKCS7_SIGNER_INFO_sign : function(si:PPKCS7_SIGNER_INFO):longint;cdecl;
  _PKCS7_add_signer : function(p7:PPKCS7; p7i:PPKCS7_SIGNER_INFO):longint;cdecl;
  _PKCS7_add_certificate : function(p7:PPKCS7; x509:PX509):longint;cdecl;
  _PKCS7_add_crl : function(p7:PPKCS7; x509: Pointer):longint;cdecl;
  _PKCS7_content_new : function(p7:PPKCS7; nid:longint):longint;cdecl;
  _PKCS7_add_signature : function(p7:PPKCS7; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):PPKCS7_SIGNER_INFO;cdecl;
  _PKCS7_cert_from_signer_info : function(p7:PPKCS7; si:PPKCS7_SIGNER_INFO):PX509;cdecl;
  _PKCS7_set_digest : function(p7:PPKCS7; md:PEVP_MD):longint;cdecl;
  _PKCS7_add_recipient : function(p7:PPKCS7; x509:PX509):PPKCS7_RECIP_INFO;cdecl;
  _PKCS7_add_recipient_info : function(p7:PPKCS7; ri:PPKCS7_RECIP_INFO):longint;cdecl;
  _PKCS7_RECIP_INFO_set : function(p7i:PPKCS7_RECIP_INFO; x509:PX509):longint;cdecl;
  _PKCS7_set_cipher : function(p7:PPKCS7; cipher:PEVP_CIPHER):longint;cdecl;
  _PKCS7_get_issuer_and_serial : function(p7:PPKCS7; idx:longint):PPKCS7_ISSUER_AND_SERIAL;cdecl;
  _PKCS7_digest_from_attributes : function(sk:Pstack_st_X509_ATTRIBUTE):Pointer;cdecl;
  _PKCS7_add_signed_attribute : function(p7si:PPKCS7_SIGNER_INFO; nid:longint; _type:longint; data:pointer):longint;cdecl;
  _PKCS7_add_attribute : function(p7si:PPKCS7_SIGNER_INFO; nid:longint; atrtype:longint; value:pointer):longint;cdecl;
  _PKCS7_get_attribute : function(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;cdecl;
  _PKCS7_get_signed_attribute : function(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;cdecl;
  _PKCS7_set_signed_attributes : function(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;cdecl;
  _PKCS7_set_attributes : function(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;cdecl;
  _PKCS7_sign : function(signcert:PX509; pkey:PEVP_PKEY; certs:Pstack_st_X509; data:PBIO; flags:longint):PPKCS7;cdecl;
  _PKCS7_sign_add_signer : function(p7:PPKCS7; signcert:PX509; pkey:PEVP_PKEY; md:PEVP_MD; flags:longint):PPKCS7_SIGNER_INFO;cdecl;
  _PKCS7_final : function(p7:PPKCS7; data:PBIO; flags:longint):longint;cdecl;
  _PKCS7_verify : function(p7:PPKCS7; certs:Pstack_st_X509; store: Pointer; indata:PBIO; _out:PBIO;  flags:longint):longint;cdecl;
  _PKCS7_encrypt : function(certs:Pstack_st_X509; _in:PBIO; cipher:PEVP_CIPHER; flags:longint):PPKCS7;cdecl;
  _PKCS7_decrypt : function(p7:PPKCS7; pkey:PEVP_PKEY; cert:PX509; data:PBIO; flags:longint):longint;cdecl;
  _PKCS7_add_attrib_smimecap : function(si:PPKCS7_SIGNER_INFO; cap:Pstack_st_X509_ALGOR):longint;cdecl;
  _PKCS7_simple_smimecap : function(sk:Pstack_st_X509_ALGOR; nid:longint; arg:longint):longint;cdecl;
  _PKCS7_add_attrib_content_type : function(si:PPKCS7_SIGNER_INFO; coid:Pointer):longint;cdecl;
  _PKCS7_add0_attrib_signing_time : function(si:PPKCS7_SIGNER_INFO; t:PASN1_TIME):longint;cdecl;
  _PKCS7_add1_attrib_digest : function(si:PPKCS7_SIGNER_INFO; md:Pbyte; mdlen:longint):longint;cdecl;
  _BIO_new_PKCS7 : function(_out:PBIO; p7:PPKCS7):PBIO;cdecl;
  _ERR_load_PKCS7_strings : procedure;cdecl;

  // BN
  _BN_new : function():PBIGNUM; cdecl;
  _BN_secure_new : function():PBIGNUM; cdecl;
  _BN_clear_free : procedure(a:PBIGNUM); cdecl;
  _BN_copy : function(a:PBIGNUM; b:PBIGNUM):PBIGNUM; cdecl;
  _BN_swap : procedure(a:PBIGNUM; b:PBIGNUM); cdecl;
  _BN_print : function(fp: pBIO; const a: PBIGNUM): cint; cdecl;
  _BN_bin2bn : function(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM; cdecl;
  _BN_bn2bin : function(a:PBIGNUM; _to:pcuchar):cint; cdecl;
  _BN_hex2bn : function(var n: PBIGNUM; const str: PAnsiChar): cint; cdecl;
  _BN_dec2bn : function(var n: PBIGNUM; const str: PAnsiChar): cint; cdecl;
  _BN_bn2hex : function(const n: PBIGNUM): PAnsiChar; cdecl;
  _BN_bn2dec : function(const n: PBIGNUM): PAnsiChar; cdecl;
  _BN_bn2binpad : function(a:PBIGNUM; _to:pcuchar; tolen:cint):cint; cdecl;
  _BN_lebin2bn : function(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM; cdecl;
  _BN_bn2lebinpad : function(a:PBIGNUM; _to:pcuchar; tolen:cint):cint; cdecl;
  _BN_mpi2bn : function(s:pcuchar; len:cint; ret:PBIGNUM):PBIGNUM; cdecl;
  _BN_bn2mpi : function(a:PBIGNUM; _to:pcuchar):cint;cdecl;
  _BN_sub : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint; cdecl;
  _BN_usub : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint; cdecl;
  _BN_uadd : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint; cdecl;
  _BN_add : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM):cint; cdecl;
  _BN_mul : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_sqr : function(r:PBIGNUM; a:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_set_negative : procedure(b:PBIGNUM; n:cint);cdecl;
  _BN_is_negative : function(b:PBIGNUM):cint;cdecl;
  _BN_div : function(dv:PBIGNUM; rem:PBIGNUM; m:PBIGNUM; d:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod : function(rem: PBIGNUM; a:PBIGNUM; m: PBIGNUM; ctx : PBN_CTX) : cint; cdecl;
  _BN_nnmod : function(r:PBIGNUM; m:PBIGNUM; d:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_add : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_add_quick : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM):cint; cdecl;
  _BN_mod_sub : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_sub_quick : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM):cint; cdecl;
  _BN_mod_mul : function(r:PBIGNUM; a:PBIGNUM; b:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_sqr : function(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_lshift1 : function(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_lshift1_quick : function(r:PBIGNUM; a:PBIGNUM; m:PBIGNUM):cint; cdecl;
  _BN_mod_lshift : function(r:PBIGNUM; a:PBIGNUM; n:cint; m:PBIGNUM; ctx:PBN_CTX):cint; cdecl;
  _BN_mod_lshift_quick : function(r:PBIGNUM; a:PBIGNUM; n:cint; m:PBIGNUM):cint; cdecl;
  _BN_mod_word : function(a:PBIGNUM; w:BN_ULONG):BN_ULONG; cdecl;
  _BN_div_word : function(a:PBIGNUM; w:BN_ULONG):BN_ULONG; cdecl;
  _BN_mul_word : function(a:PBIGNUM; w:BN_ULONG):cint; cdecl;
  _BN_add_word : function(a:PBIGNUM; w:BN_ULONG):cint; cdecl;
  _BN_sub_word : function(a:PBIGNUM; w:BN_ULONG):cint; cdecl;
  _BN_set_word : function(a:PBIGNUM; w:BN_ULONG):cint; cdecl;
  _BN_get_word : function(a:PBIGNUM):BN_ULONG; cdecl;
  _BN_cmp : function(a:PBIGNUM; b:PBIGNUM):cint; cdecl;
  _BN_free : procedure(a:PBIGNUM); cdecl;

  _OSSL_LIB_CTX_get0_global_default: function(): POSSL_LIB_CTX; cdecl;
  _OSSL_PROVIDER_available: function  (libctx: POSSL_LIB_CTX; name: PAnsiChar): cint; cdecl;
  _OSSL_PROVIDER_load: function (libctx: POSSL_LIB_CTX; name: PAnsiChar): POSSL_PROVIDER; cdecl;
  _OSSL_PROVIDER_unload: function (prov: POSSL_PROVIDER ): cint; cdecl;
  _OSSL_PROVIDER_set_default_search_path: function (libctx: POSSL_LIB_CTX; const path: PAnsiChar): cint; cdecl;

// libssl.dll

function SslGetError(s: PSSL; ret_code: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SslGetError) then
    Result := _SslGetError(s, ret_code)
  else
    Result := SSL_ERROR_SSL;
end;

function SslLibraryInit:cInt;
begin
  if InitSSLInterface and Assigned(_SslLibraryInit) then
    Result := _SslLibraryInit
  else
    Result := 1;
end;

procedure SslLoadErrorStrings;
begin
  if InitSSLInterface and Assigned(_SslLoadErrorStrings) then
    _SslLoadErrorStrings;
end;

function SslCtxSetCipherList(arg0: PSSL_CTX; var str: AnsiString): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxSetCipherList) then
    Result := _SslCtxSetCipherList(arg0, PAnsiChar(str))
  else
    Result := 0;
end;

function SslCtxNew(meth: PSSL_METHOD):PSSL_CTX;
begin
  if InitSSLInterface and Assigned(_SslCtxNew) then
    Result := _SslCtxNew(meth)
  else
    Result := nil;
end;

procedure SslCtxFree(arg0: PSSL_CTX);
begin
  if InitSSLInterface and Assigned(_SslCtxFree) then
    _SslCtxFree(arg0);
end;

function SslSetFd(s: PSSL; fd: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SslSetFd) then
    Result := _SslSetFd(s, fd)
  else
    Result := 0;
end;

function SslCtrl(ssl: PSSL; cmd: cInt; larg: clong; parg: Pointer): cLong;
begin
  if InitSSLInterface and Assigned(_SslCtrl) then
    Result := _SslCtrl(ssl, cmd, larg, parg)
  else
    Result := 0;
end;

function SslCTXCtrl(ctx: PSSL_CTX; cmd: cInt; larg: clong; parg: Pointer
  ): cLong;
begin
  if InitSSLInterface and Assigned(_SslCTXCtrl) then
    Result := _SslCTXCtrl(ctx, cmd, larg, parg)
  else
    Result := 0;
end;

function SslCtxSetMinProtoVersion(ctx: PSSL_CTX; version: integer): integer;
begin
  if InitSSLInterface and Assigned(_SslCtxSetMinProtoVersion) then
    Result := _SslCtxSetMinProtoVersion(ctx, version)
  else
    Result := 0;
end;

function SslCtxSetMaxProtoVersion(ctx: PSSL_CTX; version: integer): integer;
begin
  if InitSSLInterface and Assigned(_SslCtxSetMaxProtoVersion) then
    Result := _SslCtxSetMaxProtoVersion(ctx, version)
  else
    Result := 0;
end;

function SSLCTXSetMode(ctx: PSSL_CTX; mode: cLong): cLong;
begin
  Result := SslCTXCtrl(ctx, SSL_CTRL_MODE, mode, nil);
end;

function SSLSetMode(s: PSSL; mode: cLong): cLong;
begin
  Result := SSLctrl(s, SSL_CTRL_MODE, mode, nil);
end;

function SSLCTXGetMode(ctx: PSSL_CTX): cLong;
begin
  Result := SSLCTXctrl(ctx, SSL_CTRL_MODE, 0, nil);
end;

function SSLGetMode(s: PSSL): cLong;
begin
  Result := SSLctrl(s, SSL_CTRL_MODE, 0, nil);
end;

function SslMethodV2:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV2) then
    Result := _SslMethodV2
  else
    Result := nil;
end;

function SslMethodV3:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV3) then
    Result := _SslMethodV3
  else
    Result := nil;
end;

function SslMethodTLSV1:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodTLSV1) then
    Result := _SslMethodTLSV1
  else
    Result := nil;
end;

function SslMethodTLSV1_1:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodTLSV1_1) then
    Result := _SslMethodTLSV1_1
  else
    Result := nil;
end;

function SslMethodTLSV1_2:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodTLSV1_2) then
    Result := _SslMethodTLSV1_2
  else
    Result := nil;
end;

function SslMethodV23:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslMethodV23) then
    Result := _SslMethodV23
  else
    Result := nil;
end;

function SslTLSMethod:PSSL_METHOD;
begin
  if InitSSLInterface and Assigned(_SslTLSMethod) then
    Result := _SslTLSMethod
  else
    Result := nil;
end;

function SslCtxUsePrivateKey(ctx: PSSL_CTX; pkey: SslPtr):cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKey) then
    Result := _SslCtxUsePrivateKey(ctx, pkey)
  else
    Result := 0;
end;

function SslCtxUsePrivateKeyASN1(pk: cInt; ctx: PSSL_CTX; d: AnsiString;
  len: cLong): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKeyASN1) then
    Result := _SslCtxUsePrivateKeyASN1(pk, ctx, Sslptr(d), len)
  else
    Result := 0;
end;

function SslCtxUsePrivateKeyASN1(pk: cInt; ctx: PSSL_CTX; b: TBytes; len: cLong): cInt;overload;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKeyASN1) then
    Result := _SslCtxUsePrivateKeyASN1(pk, ctx, Sslptr(b), len)
  else
    Result := 0;
end;

function SslCtxUsePrivateKeyFile(ctx: PSSL_CTX; const _file: AnsiString;
  _type: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUsePrivateKeyFile) then
    Result := _SslCtxUsePrivateKeyFile(ctx, PAnsiChar(_file), _type)
  else
    Result := 0;
end;

function SslCtxUseCertificate(ctx: PSSL_CTX; x: SslPtr):cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificate) then
    Result := _SslCtxUseCertificate(ctx, x)
  else
    Result := 0;
end;

function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: cLong; d: AnsiString
  ): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateASN1) then
    Result := _SslCtxUseCertificateASN1(ctx, len, SslPtr(d))
  else
    Result := 0;
end;

function SslCtxUseCertificateASN1(ctx: PSSL_CTX; len: cLong; Buf: TBytes): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateASN1) then
    Result := _SslCtxUseCertificateASN1(ctx, len, SslPtr(Buf))
  else
    Result := 0;
end;

function SslCtxUseCertificateFile(ctx: PSSL_CTX; const _file: AnsiString;
  _type: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateFile) then
    Result := _SslCtxUseCertificateFile(ctx, PAnsiChar(_file), _type)
  else
    Result := 0;
end;

function SslCtxUseCertificateChainFile(ctx: PSSL_CTX; const _file: AnsiString
  ): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxUseCertificateChainFile) then
    Result := _SslCtxUseCertificateChainFile(ctx, PAnsiChar(_file))
  else
    Result := 0;
end;

function SslCtxCheckPrivateKeyFile(ctx: PSSL_CTX):cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxCheckPrivateKeyFile) then
    Result := _SslCtxCheckPrivateKeyFile(ctx)
  else
    Result := 0;
end;

procedure SslCtxSetDefaultPasswdCb(ctx: PSSL_CTX; cb: PPasswdCb);
begin
  if InitSSLInterface and Assigned(_SslCtxSetDefaultPasswdCb) then
    _SslCtxSetDefaultPasswdCb(ctx, cb);
end;

procedure SslCtxSetDefaultPasswdCbUserdata(ctx: PSSL_CTX; u: SslPtr);
begin
  if InitSSLInterface and Assigned(_SslCtxSetDefaultPasswdCbUserdata) then
    _SslCtxSetDefaultPasswdCbUserdata(ctx, u);
end;

function SslCtxLoadVerifyLocations(ctx: PSSL_CTX; const CAfile: AnsiString;
  const CApath: AnsiString): cInt;
begin
  if InitSSLInterface and Assigned(_SslCtxLoadVerifyLocations) then
    Result := _SslCtxLoadVerifyLocations(ctx, PAnsiChar(CAfile), PAnsiChar(CApath))
  else
    Result := 0;
end;

function SslNew(ctx: PSSL_CTX):PSSL;
begin
  if InitSSLInterface and Assigned(_SslNew) then
    Result := _SslNew(ctx)
  else
    Result := nil;
end;

procedure SslFree(ssl: PSSL);
begin
  if InitSSLInterface and Assigned(_SslFree) then
    _SslFree(ssl);
end;

function SslAccept(ssl: PSSL):cInt;
begin
  if InitSSLInterface and Assigned(_SslAccept) then
    Result := _SslAccept(ssl)
  else
    Result := -1;
end;

function SslConnect(ssl: PSSL):cInt;
begin
  if InitSSLInterface and Assigned(_SslConnect) then
    Result := _SslConnect(ssl)
  else
    Result := -1;
end;

function SslShutdown(ssl: PSSL):cInt;
begin
  if InitSSLInterface and Assigned(_SslShutdown) then
    Result := _SslShutdown(ssl)
  else
    Result := -1;
end;

function SslRead(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SslRead) then
    Result := _SslRead(ssl, PAnsiChar(buf), num)
  else
    Result := -1;
end;

function SslPeek(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SslPeek) then
    Result := _SslPeek(ssl, PAnsiChar(buf), num)
  else
    Result := -1;
end;

function SslWrite(ssl: PSSL; buf: SslPtr; num: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SslWrite) then
    Result := _SslWrite(ssl, PAnsiChar(buf), num)
  else
    Result := -1;
end;

function SslPending(ssl: PSSL):cInt;
begin
  if InitSSLInterface and Assigned(_SslPending) then
    Result := _SslPending(ssl)
  else
    Result := 0;
end;

function OpenSSLVersion(t: cint): AnsiString;
begin
  if InitSSLInterface and Assigned(_OpenSSLVersion) then
    Result := _OpenSSLVersion(t)
  else
    Result := '';
end;

function OpenSSLVersionNum(): cLong;
begin
  if InitSSLInterface and Assigned(_OpenSSLVersionNum) then
    Result := _OpenSSLVersionNum()
  else
    Result := 0;
end;

function OpenSSLFullVersion: String;
var
  n: clong;
  s: String;
  ps, pe: Integer;
begin
  Result := '';
  n := OpenSSLVersionNum;
  if (n > 0) then
  begin
    s := IntToHex(n, 9);
    Result := copy(s, 1, 2) + '.' + copy(s, 3, 2) + '.' + copy(s, 5, 2) + '.' + copy(s, 7, 10);
  end
  else
  begin
    s := String(OpenSSLVersion(0));
    ps := pos(' ', s);
    if (ps > 0) then
    begin
      pe := PosEx(' ', s, ps + 1);
      if (pe = 0) then
        pe := Length(s);
      Result := Trim(copy(s, ps, pe - ps));
    end;
  end;
end;

function IsOpenSSL3: Boolean;
var
  s: String;
  p: Integer;
begin
  s := OpenSSLFullVersion;
  p := pos('.', s);
  s := copy(s, 1, p-1);
  Result := (StrToIntDef(s, 0) >= 3);
end;

function SSLeay_version(t: cInt): AnsiString;
begin
  Result := OpenSSLVersion(t);
end;

function SslGetVersion(ssl: PSSL): AnsiString;
begin
  if InitSSLInterface and Assigned(_SslGetVersion) then
    Result := _SslGetVersion(ssl)
  else
    Result := '';
end;

function SslGetPeerCertificate(ssl: PSSL):PX509;
begin
  if InitSSLInterface and Assigned(_SslGetPeerCertificate) then
    Result := _SslGetPeerCertificate(ssl)
  else
    Result := nil;
end;

procedure SslCtxSetVerify(ctx: PSSL_CTX; mode: cInt; arg2: TSSLCTXVerifyCallback);
begin
  if InitSSLInterface and Assigned(_SslCtxSetVerify) then
    _SslCtxSetVerify(ctx, mode, @arg2);
end;

function SSLGetCurrentCipher(s: PSSL):SslPtr;
begin
  if InitSSLInterface and Assigned(_SSLGetCurrentCipher) then
{$IFDEF CIL}
{$ELSE}
    Result := _SSLGetCurrentCipher(s)
{$ENDIF}
  else
    Result := nil;
end;

function SSLCipherGetName(c: SslPtr): AnsiString;
begin
  if InitSSLInterface and Assigned(_SSLCipherGetName) then
    Result := _SSLCipherGetName(c)
  else
    Result := '';
end;

function SSLCipherGetBits(c: SslPtr; var alg_bits: cInt):cInt;
begin
  if InitSSLInterface and Assigned(_SSLCipherGetBits) then
    Result := _SSLCipherGetBits(c, @alg_bits)
  else
    Result := 0;
end;

function SSLGetVerifyResult(ssl: PSSL):cLong;
begin
  if InitSSLInterface and Assigned(_SSLGetVerifyResult) then
    Result := _SSLGetVerifyResult(ssl)
  else
    Result := X509_V_ERR_APPLICATION_VERIFICATION;
end;

function SSLGetServername(ssl: PSSL; _type: cInt): AnsiString;
begin
  if InitSSLInterface and Assigned(_SSLGetServername) then
    result := PAnsiChar(_SSLGetServername(ssl, _type))
  else
    result := '';
end;

procedure SslCtxCallbackCtrl(ssl: PSSL; _type: cInt; cb: PCallbackCb);
begin
  if InitSSLInterface and Assigned(_SslCtxCallbackCtrl) then
    _SslCtxCallbackCtrl(ssl, _type, cb);
end;

function SslSetSslCtx(ssl: PSSL; ctx: PSSL_CTX): PSSL;
begin
  if InitSSLInterface and Assigned(_SslSetSslCtx) then
    result := _SslSetSslCtx(ssl, ctx)
  else
    result := nil;
end;

// libeay.dll
procedure ERR_load_crypto_strings;
Begin
  if InitSSLInterface and Assigned(_ERR_load_crypto_strings) then
    _ERR_load_crypto_strings;
end;

function X509New: PX509;
begin
  if InitSSLInterface and Assigned(_X509New) then
    Result := _X509New
  else
    Result := nil;
end;

procedure X509Free(x: PX509);
begin
  if InitSSLInterface and Assigned(_X509Free) then
    _X509Free(x);
end;

function X509_NAME_new: PX509_NAME;
begin
  if InitSSLInterface and Assigned(_X509_NAME_new) then
    Result := _X509_NAME_new
  else
    Result := nil;
end;

procedure X509_NAME_free(a: PX509_NAME);
begin
  if InitSSLInterface and Assigned(_X509_NAME_free) then
    _X509_NAME_free(a);
end;

function X509NameOneline(a: PX509_NAME; var buf: AnsiString; size: cInt
  ): AnsiString;
begin
  if InitSSLInterface and Assigned(_X509NameOneline) then
    Result := _X509NameOneline(a, PAnsiChar(buf),size)
  else
    Result := '';
end;

function X509NAMEprintEx(b: PBIO; x: PX509_NAME; indent: cInt; flags: cuint): cInt;
begin
  if InitSSLInterface and Assigned(_X509NAMEprintEx) then
    Result := _X509NAMEprintEx(b, x, indent, flags)
  else
    Result := 0;
end;

function X509GetSubjectName(a: PX509):PX509_NAME;
begin
  if InitSSLInterface and Assigned(_X509GetSubjectName) then
    Result := _X509GetSubjectName(a)
  else
    Result := nil;
end;

function X509GetIssuerName(a: PX509):PX509_NAME;
begin
  if InitSSLInterface and Assigned(_X509GetIssuerName) then
    Result := _X509GetIssuerName(a)
  else
    Result := nil;
end;

function X509NameHash(x: PX509_NAME):cuLong;
begin
  if InitSSLInterface and Assigned(_X509NameHash) then
    Result := _X509NameHash(x)
  else
    Result := 0;
end;

function X509Digest(data: PX509; _type: PEVP_MD; md: AnsiString; var len: cInt
  ): cInt;
begin
  if InitSSLInterface and Assigned(_X509Digest) then
    Result := _X509Digest(data, _type, PAnsiChar(md), @len)
  else
    Result := 0;
end;

function EvpPkeyNew: PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_EvpPkeyNew) then
    Result := _EvpPkeyNew
  else
    Result := nil;
end;

procedure EvpPkeyFree(pk: PEVP_PKEY);
begin
  if InitSSLInterface and Assigned(_EvpPkeyFree) then
    _EvpPkeyFree(pk);
end;

procedure ErrErrorString(e: cInt; var buf: AnsiString; len: cInt);
begin
  if InitSSLInterface and Assigned(_ErrErrorString) then
    _ErrErrorString(e, @buf[1], len)
  else
    buf := SFailedToLoadOpenSSL;
  buf := PAnsiChar(Buf);
end;

function ErrGetError: cInt;
begin
  if InitSSLInterface and Assigned(_ErrGetError) then
    Result := _ErrGetError
  else
    Result := SSL_ERROR_SSL;
end;

procedure ErrClearError;
begin
  if InitSSLInterface and Assigned(_ErrClearError) then
    _ErrClearError;
end;

procedure ErrFreeStrings;
begin
  if InitSSLInterface and Assigned(_ErrFreeStrings) then
    _ErrFreeStrings;
end;

procedure ErrRemoveState(pid: cInt);
begin
  if InitSSLInterface and Assigned(_ErrRemoveState) then
    _ErrRemoveState(pid);
end;

procedure EVPcleanup;
begin
  if InitSSLInterface and Assigned(_EVPcleanup) then
    _EVPcleanup;
end;

procedure RandScreen;
begin
  if InitSSLInterface and Assigned(_RandScreen) then
    _RandScreen;
end;

function BioNew(b: PBIO_METHOD): PBIO;
begin
  if InitSSLInterface and Assigned(_BioNew) then
    Result := _BioNew(b)
  else
    Result := nil;
end;

procedure BioFreeAll(b: PBIO);
begin
  if InitSSLInterface and Assigned(_BioFreeAll) then
    _BioFreeAll(b);
end;

function BioSMem: PBIO_METHOD;
begin
  if InitSSLInterface and Assigned(_BioSMem) then
    Result := _BioSMem
  else
    Result := nil;
end;


function BioCtrlPending(b: PBIO): cInt;
begin
  if InitSSLInterface and Assigned(_BioCtrlPending) then
    Result := _BioCtrlPending(b)
  else
    Result := 0;
end;

function BioRead(b: PBIO; Buf: TBytes; Len: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_BioRead) then
    Result := _BioRead(b, PAnsiChar(Buf), Len)
  else
    Result := -2;
end;

function BioRead(b: PBIO; var Buf: AnsiString; Len: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_BioRead) then
    Result := _BioRead(b, PAnsiChar(Buf), Len)
  else
    Result := -2;
end;

function BioWrite(b: PBIO; Buf: AnsiString; Len: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_BioWrite) then
    Result := _BioWrite(b, PAnsiChar(Buf), Len)
  else
    Result := -2;
end;

function BioWrite(b: PBIO; Buf: TBytes; Len: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_BioWrite) then
    Result := _BioWrite(b, PAnsiChar(Buf), Len)
  else
    Result := -2;
end;

function BIOReset(b: pBIO): cint;
begin
  if InitSSLInterface and Assigned(_BioReset) then
    Result := _BioReset(b)
  else
    Result := -2;
end;

function X509print(b: PBIO; a: PX509): cInt;
begin
  if InitSSLInterface and Assigned(_X509print) then
    Result := _X509print(b, a)
  else
    Result := 0;
end;

function d2iPKCS12bio(b:PBIO; Pkcs12: SslPtr): SslPtr;
begin
  if InitSSLInterface and Assigned(_d2iPKCS12bio) then
    Result := _d2iPKCS12bio(b, Pkcs12)
  else
    Result := nil;
end;

function PKCS12parse(p12: SslPtr; pass: AnsiString; var pkey: pEVP_PKEY;
  var cert: pX509; var ca: SslPtr): cInt;
begin
  if InitSSLInterface and Assigned(_PKCS12parse) then
    Result := _PKCS12parse(p12, PAnsiChar(pass), pkey, cert, ca)
  else
    Result := 0;
end;

procedure PKCS12free(p12: SslPtr);
begin
  if InitSSLInterface and Assigned(_PKCS12free) then
    _PKCS12free(p12);
end;

function EvpPkeyAssign(pkey: PEVP_PKEY; _type: cInt; key: Prsa): cInt;
begin
  if InitSSLInterface and Assigned(_EvpPkeyAssign) then
    Result := _EvpPkeyAssign(pkey, _type, key)
  else
    Result := 0;
end;

function EvpPkeyGet1RSA(pkey: PEVP_PKEY): pRSA;
begin
  if InitSSLInterface and Assigned(_EvpPkeyGet1RSA) then
    Result := _EvpPkeyGet1RSA(pkey)
  else
    Result := nil;
end;

function EvpPkeySet1RSA(pkey: PEVP_PKEY; rsa: pRSA): cInt;
begin
  if InitSSLInterface and Assigned(_EvpPkeySet1RSA) then
    Result := _EvpPkeySet1RSA(pkey, rsa)
  else
    Result := 0;
end;

function X509SetVersion(x: PX509; version: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_X509SetVersion) then
    Result := _X509SetVersion(x, version)
  else
    Result := 0;
end;

function X509SetPubkey(x: PX509; pkey: PEVP_PKEY): cInt;
begin
  if InitSSLInterface and Assigned(_X509SetPubkey) then
    Result := _X509SetPubkey(x, pkey)
  else
    Result := 0;
end;

function X509GetPubkey(x: PX509): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_X509GetPubkey) then
    Result := _X509GetPubkey(x)
  else
   Result := Nil;
end;


function X509SetIssuerName(x: PX509; name: PX509_NAME): cInt;
begin
  if InitSSLInterface and Assigned(_X509SetIssuerName) then
    Result := _X509SetIssuerName(x, name)
  else
    Result := 0;
end;

function X509NameAddEntryByTxt(name: PX509_NAME; field: Ansistring;
  _type: cInt; bytes: AnsiString; len, loc, _set: cInt): cInt;
begin
  if InitSSLInterface and Assigned(_X509NameAddEntryByTxt) then
    Result := _X509NameAddEntryByTxt(name, PAnsiChar(field), _type, PAnsiChar(Bytes), len, loc, _set)
  else
    Result := 0;
end;

function X509Sign(x: PX509; pkey: PEVP_PKEY; const md: PEVP_MD): cInt;
begin
  if InitSSLInterface and Assigned(_X509Sign) then
    Result := _X509Sign(x, pkey, md)
  else
    Result := 0;
end;

function Asn1UtctimeNew: PASN1_UTCTIME;
begin
  Result:=PASN1_UTCTIME(Asn1StringTypeNew(V_ASN1_UTCTIME));
end;

function Asn1StringTypeNew(aType : cint): PASN1_STRING;

begin
  if InitSSLInterface and Assigned(_Asn1StringTypeNew) then
    Result := _Asn1StringTypeNew(aType)
  else
    Result := nil;
end;

procedure Asn1UtctimeFree(a: PASN1_UTCTIME);
begin
  if InitSSLInterface and Assigned(_Asn1UtctimeFree) then
    _Asn1UtctimeFree(a);
end;

function Asn1UtctimePrint(b: PBio; a: PASN1_UTCTIME): integer;
begin
  if InitSSLInterface and Assigned(_Asn1UtctimePrint) then
    Result:=_Asn1UtctimePrint(b,a)
  else
    Result:=0;
end;

function ASN1UtcTimeSetString(t: PASN1_UTCTIME; s: PAnsichar): cint;
begin
  if InitSSLInterface and Assigned(_Asn1UtctimeSetString) then
    Result:=_Asn1UtctimeSetString(t,s)
  else
    Result:=0;
end;

function Asn1IntegerSet(a: PASN1_INTEGER; v: integer): integer;
begin
  if InitSSLInterface and Assigned(_Asn1IntegerSet) then
    Result := _Asn1IntegerSet(a, v)
  else
    Result := 0;
end;

function Asn1IntegerGet(a: PASN1_INTEGER): integer;
begin
  if InitSSLInterface and Assigned(_Asn1IntegerGet) then
    Result := _Asn1IntegerGet(a)
  else
    Result := 0;
end;

function X509GmtimeAdj(s: PASN1_UTCTIME; adj: cInt): PASN1_UTCTIME;
begin
  if InitSSLInterface and Assigned(_X509GmtimeAdj) then
    Result := _X509GmtimeAdj(s, adj)
  else
    Result := nil;
end;

function X509GetNotBefore(x: pX509): pASN1_TIME;
begin
  if InitSSLInterface and Assigned(_X509GetNotBefore) then
    Result := _X509GetNotBefore(x)
  else
    Result := Nil;
end;

function X509GetNotAfter(x: pX509): pASN1_TIME;
begin
  Result := Nil;
  if (not InitSSLInterface) or (not Assigned(x)) then
    Exit;

  if Assigned(_X509GetNotAfter) then
    Result := _X509GetNotAfter(x)
  else
    Result := x^.cert_info^.validity^.notAfter;
end;

function X509SetNotBefore(x: PX509; tm: PASN1_UTCTIME): cInt;
begin
  if InitSSLInterface and Assigned(_X509SetNotBefore) then
    Result := _X509SetNotBefore(x, tm)
  else
    Result := 0;
end;

function X509SetNotAfter(x: PX509; tm: PASN1_UTCTIME): cInt;
begin
  if InitSSLInterface and Assigned(_X509SetNotAfter) then
    Result := _X509SetNotAfter(x, tm)
  else
    Result := 0;
end;

function i2dX509bio(b: PBIO; x: PX509): cInt;
begin
  if InitSSLInterface and Assigned(_i2dX509bio) then
    Result := _i2dX509bio(b, x)
  else
    Result := 0;
end;

function d2iX509bio(b: pBIO; x: PX509): PX509;
begin
  if InitSSLInterface and Assigned(_d2iX509bio) then
    Result := _d2iX509bio(b, x)
  else
    Result := Nil;
end;

function i2dPrivateKeyBio(b: PBIO; pkey: PEVP_PKEY): cInt;
begin
  if InitSSLInterface and Assigned(_i2dPrivateKeyBio) then
    Result := _i2dPrivateKeyBio(b, pkey)
  else
    Result := 0;
end;

function OPENSSL_sk_num(Stack: PSTACK): Integer;
begin
  if InitSSLInterface and Assigned(_OPENSSL_sk_num) then
    Result := _OPENSSL_sk_num(Stack)
  else
    Result := -1;
end;

function SSL_CTX_get_cert_store(const Ctx: PSSL_CTX): PX509_STORE;
begin
  if InitSSLInterface and Assigned(_SSL_CTX_get_cert_store) then
    Result := _SSL_CTX_get_cert_store(Ctx)
  else
    Result := Nil;
end;

function OPENSSL_sk_value(Stack: PSTACK; Item: Integer): PAnsiChar;
begin
  if InitSSLInterface and Assigned(_OPENSSL_sk_value) then
    Result := _OPENSSL_sk_value(Stack, Item)
  else
    Result := Nil;
end;

procedure OPENSSL_sk_pop_free(Stack: PSTACK; func: Tsk_pop_free_func);
begin
  if InitSSLInterface and Assigned(_OPENSSL_sk_pop_free) then
    _OPENSSL_sk_pop_free(Stack, func);
end;

function X509_STORE_add_cert(Store: PX509_STORE; Cert: PX509): Integer;
begin
  if InitSSLInterface and Assigned(_X509_STORE_add_cert) then
    Result := _X509_STORE_add_cert(Store, Cert)
  else
    Result := -1;
end;

function EvpGetDigestByName(Name: AnsiString): PEVP_MD;
begin
  if InitSSLInterface and Assigned(_EvpGetDigestByName) then
    Result := _EvpGetDigestByName(PAnsiChar(Name))
  else
    Result := nil;
end;

function X509GetSerialNumber(x: PX509): PASN1_cInt;
begin
  if InitSSLInterface and Assigned(_X509GetSerialNumber) then
    Result := _X509GetSerialNumber(x)
  else
    Result := nil;
end;

function X509GetExt(x: PX509; loc: integer): pX509_EXTENSION;
begin
  if InitSSLInterface and Assigned(_X509GetExt) then
    Result := _X509GetExt(x, loc)
  else
    Result := nil;
end;

function X509ExtensionGetData(ext: pX509_EXTENSION): pASN1_STRING;
begin
  Result := Nil;
  if (not InitSSLInterface) or (not Assigned(ext)) then
    Exit;

  if Assigned(_X509ExtensionGetData) then
    Result := _X509ExtensionGetData(ext)
  else
    Result := ext^.value;
end;

function X509_REQ_new: PX509_REQ;
begin
  if InitSSLInterface and Assigned(_X509_REQ_new) then
    Result := _X509_REQ_new
  else
    Result := nil;
end;

procedure X509_REQ_free(x: PX509_REQ);
begin
  if InitSSLInterface and Assigned(_X509_REQ_free) then
    _X509_REQ_free(x);
end;

function X509_REQ_set_subject_name(req: PX509_REQ; name: PX509_NAME): cInt;
begin
  if InitSSLInterface and Assigned(_X509_REQ_set_subject_name) then
    Result := _X509_REQ_set_subject_name(req,name)
  else
    Result := -1;
end;

function X509_REQ_set_pubkey(x: PX509_REQ; pkey: PEVP_PKEY): cInt;
begin
  if InitSSLInterface and Assigned(_X509_REQ_set_pubkey) then
    Result := _X509_REQ_set_pubkey(x, pkey)
  else
    Result := -1;
end;

function X509_REQ_sign(x: PX509_REQ; pkey: PEVP_PKEY; const md: PEVP_MD): cInt;
begin
  if InitSSLInterface and Assigned(_X509_REQ_sign) then
    Result := _X509_REQ_sign(x, pkey, md)
  else
    Result := -1;
end;


// 3DES functions
procedure DESsetoddparity(Key: des_cblock);
begin
  if InitSSLInterface and Assigned(_DESsetoddparity) then
    _DESsetoddparity(Key);
end;

function DESsetkey(key: des_cblock; schedule: des_key_schedule): cInt;
begin
  if InitSSLInterface and Assigned(_DESsetkey) then
    Result := _DESsetkey(key, schedule)
  else
    Result := -1;
end;

function DESsetkeychecked(key: des_cblock; schedule: des_key_schedule): cInt;
begin
  if InitSSLInterface and Assigned(_DESsetkeychecked) then
    Result := _DESsetkeychecked(key, schedule)
  else
    Result := -1;
end;

procedure DESecbencrypt(Input: des_cblock; output: des_cblock; ks: des_key_schedule; enc: cInt);
begin
  if InitSSLInterface and Assigned(_DESecbencrypt) then
    _DESecbencrypt(Input, output, ks, enc);
end;

// RAND functions
function RAND_set_rand_method(const meth: PRAND_METHOD): cint;
begin
  if InitSSLInterface and Assigned(_RAND_set_rand_method) then
    Result := _RAND_set_rand_method(meth)
  else
    Result := -1;
end;

function RAND_get_rand_method: PRAND_METHOD;
begin
  if InitSSLInterface and Assigned(_RAND_get_rand_method) then
    Result := _RAND_get_rand_method()
  else
    Result := nil;
end;

function RAND_SSLeay: PRAND_METHOD;
begin
  if InitSSLInterface and Assigned(_RAND_SSLeay) then
    Result := _RAND_SSLeay()
  else
    Result := nil;
end;

procedure RAND_cleanup;
begin
  if InitSSLInterface and Assigned(_RAND_cleanup) then
    _RAND_cleanup();
end;

function RAND_bytes(buf: PByte; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_bytes) then
    Result := _RAND_bytes(buf, num)
  else
    Result := -1;
end;

function RAND_pseudo_bytes(buf: PByte; num: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_pseudo_bytes) then
    Result := _RAND_pseudo_bytes(buf, num)
  else
    Result := -1;
end;

procedure RAND_seed(const buf: Pointer; num: cint);
begin
  if InitSSLInterface and Assigned(_RAND_seed) then
    _RAND_seed(buf, num);
end;

procedure RAND_add(const buf: Pointer; num: cint; entropy: cdouble);
begin
  if InitSSLInterface and Assigned(_RAND_add) then
    _RAND_add(buf, num, entropy);
end;

function RAND_load_file(const file_name: PAnsiChar; max_bytes: clong): cint;
begin
  if InitSSLInterface and Assigned(_RAND_load_file) then
    Result := _RAND_load_file(file_name, max_bytes)
  else
    Result := -1;
end;

function RAND_write_file(const file_name: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_RAND_write_file) then
    Result := _RAND_write_file(file_name)
  else
    Result := -1;
end;

function RAND_file_name(file_name: PAnsiChar; num: csize_t): PAnsiChar;
begin
  if InitSSLInterface and Assigned(_RAND_file_name) then
    Result := _RAND_file_name(file_name, num)
  else
    Result := nil;
end;

function RAND_status: cint;
begin
  if InitSSLInterface and Assigned(_RAND_status) then
    Result := _RAND_status()
  else
    Result := -1;
end;

function RAND_query_egd_bytes(const path: PAnsiChar; buf: PByte; bytes: cint
  ): cint;
begin
  if InitSSLInterface and Assigned(_RAND_query_egd_bytes) then
    Result := _RAND_query_egd_bytes(path, buf, bytes)
  else
    Result := -1;
end;

function RAND_egd(const path: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_RAND_egd) then
    Result := _RAND_egd(path)
  else
    Result := -1;
end;

function RAND_egd_bytes(const path: PAnsiChar; bytes: cint): cint;
begin
  if InitSSLInterface and Assigned(_RAND_egd_bytes) then
    Result := _RAND_egd_bytes(path, bytes)
  else
    Result := -1;
end;

procedure ERR_load_RAND_strings;
begin
  if InitSSLInterface and Assigned(_ERR_load_RAND_strings) then
    _ERR_load_RAND_strings();
end;

function RAND_poll: cint;
begin
  if InitSSLInterface and Assigned(_RAND_poll) then
    Result := _RAND_poll()
  else
    Result := -1;
end;

// RSA Functions

function RSA_new(): PRSA;
begin
  if InitSSLInterface and Assigned(_RSA_new) then
    Result := _RSA_new()
  else
    Result := nil;
end;

function RSA_new_method(method: PENGINE): PRSA;
begin
  if InitSSLInterface and Assigned(_RSA_new_method) then
    Result := _RSA_new_method(method)
  else
    Result := nil;
end;

function RSA_size(arsa: PRSA): cint;
begin
  if InitSSLInterface and Assigned(_RSA_size) then
    Result := _RSA_size(arsa)
  else
    Result := -1;
end;

function RsaGenerateKey(bits, e: cInt; callback: PFunction; cb_arg: SslPtr): PRSA;
begin
  if InitSSLInterface and Assigned(_RsaGenerateKey) then
    Result := _RsaGenerateKey(bits, e, callback, cb_arg)
  else
    Result := nil;
end;

function RSA_generate_key_ex(arsa: PRSA; bits: cInt; e: PBIGNUM; cb: PBN_GENCB): cint;
begin
  if InitSSLInterface and Assigned(_RSA_generate_key_ex) then
    Result := _RSA_generate_key_ex(arsa, bits, e, cb)
  else
    Result := 0;
end;

function RSA_check_key(arsa: PRSA): cint;
begin
  if InitSSLInterface and Assigned(_RSA_check_key) then
    Result := _RSA_check_key(arsa)
  else
    Result := -1;
end;

function RSA_public_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_public_encrypt) then
    Result := _RSA_public_encrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_private_encrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_private_encrypt) then
    Result := _RSA_private_encrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_public_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_public_decrypt) then
    Result := _RSA_public_decrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

function RSA_private_decrypt(flen: cint; from_buf, to_buf: PByte; arsa: PRSA; padding: cint): cint;
begin
  if InitSSLInterface and Assigned(_RSA_private_decrypt) then
    Result := _RSA_private_decrypt(flen, from_buf, to_buf, arsa, padding)
  else
    Result := -1;
end;

procedure RSA_free(arsa: PRSA);
begin
  if InitSSLInterface and Assigned(_RSA_free) then
    _RSA_free(arsa);
end;

function RSA_flags(arsa: PRSA): Integer;
begin
  if InitSSLInterface and Assigned(_RSA_flags) then
    Result := _RSA_flags(arsa)
  else
    Result := -1;
end;

procedure RSA_set_default_method(method: PRSA_METHOD);
begin
  if InitSSLInterface and Assigned(_RSA_set_default_method) then
    _RSA_set_default_method(method);
end;

function RSA_get_default_method: PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_get_default_method) then
    Result := _RSA_get_default_method()
  else
    Result := nil;
end;

function RSA_get_method(arsa: PRSA): PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_get_method) then
    Result := _RSA_get_method(arsa)
  else
    Result := nil;
end;

function RSA_set_method(arsa: PRSA; method: PRSA_METHOD): PRSA_METHOD;
begin
  if InitSSLInterface and Assigned(_RSA_set_method) then
    Result := _RSA_set_method(arsa, method)
  else
    Result := nil;
end;

function RSA_get0_n(const d :PRSA) :PBIGNUM;
begin
  if InitSSLInterface and Assigned(_RSA_get0_n) then
    Result := _RSA_get0_n(d)
  else if Assigned(d) and Assigned(d^.n) then
    Result := d^.n
  else
    Result := nil;
end;

function RSA_get0_e(const d :PRSA) :PBIGNUM;
begin
  if InitSSLInterface and Assigned(_RSA_get0_e) then
    Result := _RSA_get0_e(d)
  else if Assigned(d) and Assigned(d^.e) then
    Result := d^.e
  else
    Result := nil;
end;

function RSA_get0_d(const d: PRSA): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_RSA_get0_d) then
    Result := _RSA_get0_d(d)
  else if Assigned(d) and Assigned(d^.d) then
    Result := d^.d
  else
    Result := nil;
end;

function RSA_get0_p(const d: PRSA): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_RSA_get0_p) then
    Result := _RSA_get0_p(d)
  else if Assigned(d) and Assigned(d^.p) then
    Result := d^.p
  else
    Result := nil;
end;

function RSA_get0_q(const d: PRSA): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_RSA_get0_q) then
    Result := _RSA_get0_q(d)
  else if Assigned(d) and Assigned(d^.q) then
    Result := d^.q
  else
    Result := nil;
end;

function RSA_set0_key(r: pRSA; n: PBIGNUM; e: PBIGNUM; d: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_RSA_set0_key) then
    Result := _RSA_set0_key(r, n, e, d)
  else
    Result := -1;
end;

function RSA_get_version(r :PRSA) :cint;
begin
  if InitSSLInterface and Assigned(_RSA_get_version) then
    Result := _RSA_get_version(r)
  else
    Result := -1; // or 0 = RSA_ASN1_VERSION_DEFAULT
end;

function RSA_pkey_ctx_ctrl(ctx: PEVP_PKEY_CTX; optype: cint; cmd: cint;
  p1: cint; p2: Pointer): cint;
begin
  if InitSSLInterface and Assigned(_RSA_pkey_ctx_ctrl) then
    Result := _RSA_pkey_ctx_ctrl(ctx, optype, cmd, p1, p2)
  else
    Result := -1;
end;

function d2i_RSAPublicKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
begin
  if InitSSLInterface and Assigned(_d2i_RSAPublicKey) then
    Result := _d2i_RSAPublicKey(arsa, pp, len)
  else
    Result := nil;
end;

function i2d_RSAPublicKey(arsa: PRSA; pp: PPByte): cint;
begin
  if InitSSLInterface and Assigned(_i2d_RSAPublicKey) then
    Result := _i2d_RSAPublicKey(arsa, pp)
  else
    Result := -1;
end;

function d2i_RSAPrivateKey(arsa: PPRSA; pp: PPByte; len: cint): PRSA;
begin
  if InitSSLInterface and Assigned(_d2i_RSAPrivateKey) then
    Result := _d2i_RSAPrivateKey(arsa, pp, len)
  else
    Result := nil;
end;

function i2d_RSAPrivateKey(arsa: PRSA; pp: PPByte): cint;
begin
  if InitSSLInterface and Assigned(_i2d_RSAPrivateKey) then
    Result := _i2d_RSAPrivateKey(arsa, pp)
  else
    Result := -1;
end;

function d2i_PubKey(a: PPEVP_PKEY; pp: PPByte; len: clong): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_d2i_PubKey) then
    Result := _d2i_PubKey(a, pp, len)
  else
    Result := nil;
end;

function d2i_AutoPrivateKey(a: PPEVP_PKEY; pp: PPByte; len: clong): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_d2i_AutoPrivateKey) then
    Result := _d2i_AutoPrivateKey(a, pp, len)
  else
    Result := nil;
end;

// ERR Functions

function Err_Error_String(e: cInt; buf: PAnsiChar): PAnsiChar;
begin
  if InitSSLInterface and Assigned(_Err_Error_String) then
    Result := _Err_Error_String(e, buf)
  else
    Result := nil;
end;

// EVP Functions

function EVP_des_ede3_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_des_ede3_cbc) then
    Result := _EVP_des_ede3_cbc()
  else
    Result := Nil;
end;

function EVP_enc_null: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_enc_null) then
    Result := _EVP_enc_null()
  else
    Result := Nil;
end;

function EVP_rc2_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_cbc) then
    Result := _EVP_rc2_cbc()
  else
    Result := Nil;
end;

function EVP_rc2_40_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_40_cbc) then
    Result := _EVP_rc2_40_cbc()
  else
    Result := Nil;
end;

function EVP_rc2_64_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc2_64_cbc) then
    Result := _EVP_rc2_64_cbc()
  else
    Result := Nil;
end;

function EVP_rc4: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc4) then
    Result := _EVP_rc4()
  else
    Result := Nil;
end;

function EVP_rc4_40: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_rc4_40) then
    Result := _EVP_rc4_40()
  else
    Result := Nil;
end;

function EVP_des_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_des_cbc) then
    Result := _EVP_des_cbc()
  else
    Result := Nil;
end;

function EVP_aes_128_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_128_cbc) then
    Result := _EVP_aes_128_cbc()
  else
    Result := Nil;
end;

function EVP_aes_192_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_192_cbc) then
    Result := _EVP_aes_192_cbc()
  else
    Result := Nil;
end;

function EVP_aes_256_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_256_cbc) then
    Result := _EVP_aes_256_cbc()
  else
    Result := Nil;
end;

function EVP_aes_128_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_128_cfb8) then
    Result := _EVP_aes_128_cfb8()
  else
    Result := Nil;
end;

function EVP_aes_192_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_192_cfb8) then
    Result := _EVP_aes_192_cfb8()
  else
    Result := Nil;
end;

function EVP_aes_256_cfb8: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_aes_256_cfb8) then
    Result := _EVP_aes_256_cfb8()
  else
    Result := Nil;
end;

function EVP_camellia_128_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_128_cbc) then
    Result := _EVP_camellia_128_cbc()
  else
    Result := Nil;
end;

function EVP_camellia_192_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_192_cbc) then
    Result := _EVP_camellia_192_cbc()
  else
    Result := Nil;
end;

function EVP_camellia_256_cbc: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_camellia_256_cbc) then
    Result := _EVP_camellia_256_cbc()
  else
    Result := Nil;
end;

function EVP_sha256: PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_sha256) then
    Result := _EVP_sha256()
  else
    Result := Nil;
end;


procedure OpenSSL_add_all_algorithms;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_algorithms) then
    _OpenSSL_add_all_algorithms();
end;

procedure OpenSSL_add_all_ciphers;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_ciphers) then
    _OpenSSL_add_all_ciphers();
end;

procedure OpenSSL_add_all_digests;
begin
  if InitSSLInterface and Assigned(_OpenSSL_add_all_digests) then
    _OpenSSL_add_all_digests();
end;
//
function EVP_DigestInit(ctx: PEVP_MD_CTX; type_: PEVP_MD): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestInit) then
    Result := _EVP_DigestInit(ctx, type_)
  else
    Result := -1;
end;

function EVP_DigestUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestUpdate) then
    Result := _EVP_DigestUpdate(ctx, data, cnt)
  else
    Result := -1;
end;

function EVP_DigestFinal(ctx: PEVP_MD_CTX; md: PByte; s: pcuint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestFinal) then
    Result := _EVP_DigestFinal(ctx, md, s)
  else
    Result := -1;
end;

function EVP_SignFinal(ctx: pEVP_MD_CTX; sig: pointer; var s: cardinal;
    key: pEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_SignFinal) then
    Result := _EVP_SignFinal(ctx, sig, s, key)
  else
    Result := -1;
end;

function EVP_PKEY_size(key: pEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_size) then
    Result := _EVP_PKEY_size(key)
  else
    Result := -1;
end;

procedure EVP_PKEY_free(key: pEVP_PKEY);
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_free) then
    _EVP_PKEY_free(key);
end;

function EVP_PKEY_new_mac_key(type_: cint; e: PENGINE; key: PByte; keylen :cint): PEVP_PKEY;  // Tz HMAC
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_new_mac_key) then
    result := _EVP_PKEY_new_mac_key(type_, e, key, keylen)
  else
    result := nil;
end;

function EVP_VerifyFinal(ctx: pEVP_MD_CTX; sigbuf: pointer;
    siglen: cardinal; pkey: pEVP_PKEY): integer;
begin
  if InitSSLInterface and Assigned(_EVP_VerifyFinal) then
    Result := _EVP_VerifyFinal(ctx, sigbuf, siglen, pkey)
  else
    Result := -1;
end;


//
function EVP_get_cipherbyname(const name: PAnsiChar): PEVP_CIPHER;
begin
  if InitSSLInterface and Assigned(_EVP_get_cipherbyname) then
    Result := _EVP_get_cipherbyname(name)
  else
    Result := nil;
end;

function EVP_get_digestbyname(const name: PAnsiChar): PEVP_MD;
begin
  if InitSSLInterface and Assigned(_EVP_get_digestbyname) then
    Result := _EVP_get_digestbyname(name)
  else
    Result := nil;
end;
//
procedure EVP_CIPHER_CTX_init(a: PEVP_CIPHER_CTX);
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_init) then
    _EVP_CIPHER_CTX_init(a);
end;

function EVP_CIPHER_CTX_cleanup(a: PEVP_CIPHER_CTX): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_cleanup) then
    Result := _EVP_CIPHER_CTX_cleanup(a)
  else
    Result := -1;
end;

function EVP_CIPHER_CTX_new: PEVP_CIPHER_CTX;            // Tz Cipher
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_new) then
    Result := _EVP_CIPHER_CTX_new
  else
    Result := nil;
end;

procedure EVP_CIPHER_CTX_free(ctx :PEVP_CIPHER_CTX);     // Tz Cipher
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_free) then
    _EVP_CIPHER_CTX_free(ctx);
end;

function EVP_CIPHER_CTX_set_key_length(x: PEVP_CIPHER_CTX; keylen: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_set_key_length) then
    Result := _EVP_CIPHER_CTX_set_key_length(x, keylen)
  else
    Result := -1;
end;

function EVP_CIPHER_CTX_ctrl(ctx: PEVP_CIPHER_CTX; type_, arg: cint; ptr: Pointer): cint;
begin
  if InitSSLInterface and Assigned(_EVP_CIPHER_CTX_ctrl) then
    Result := _EVP_CIPHER_CTX_ctrl(ctx, type_, arg, ptr)
  else
    Result := -1;
end;
//
function EVP_EncryptInit(ctx: PEVP_CIPHER_CTX; const chipher_: PEVP_CIPHER;
         const key, iv: PByte): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptInit) then
    Result := _EVP_EncryptInit(ctx, chipher_, key, iv)
  else
    Result := -1;
end;

function EVP_EncryptUpdate(ctx: PEVP_CIPHER_CTX; out_: pcuchar;
         outlen: pcint; const in_: pcuchar; inlen: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptUpdate) then
    Result := _EVP_EncryptUpdate(ctx, out_, outlen, in_, inlen)
  else
    Result := -1;
end;

function EVP_EncryptFinal(ctx: PEVP_CIPHER_CTX; out_data: PByte; outlen: pcint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_EncryptFinal) then
    Result := _EVP_EncryptFinal(ctx, out_data, outlen)
  else
    Result := -1;
end;
//
function EVP_DecryptInit(ctx: PEVP_CIPHER_CTX; chiphir_type: PEVP_CIPHER;
         const key, iv: PByte): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptInit) then
    Result := _EVP_DecryptInit(ctx, chiphir_type, key, iv)
  else
    Result := -1;
end;

function EVP_DecryptUpdate(ctx: PEVP_CIPHER_CTX; out_data: PByte;
         outl: pcint; const in_: PByte; inl: cint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptUpdate) then
    Result := _EVP_DecryptUpdate(ctx, out_data, outl, in_, inl)
  else
    Result := -1;
end;

function EVP_DecryptFinal(ctx: PEVP_CIPHER_CTX; outm: PByte; outlen: pcint): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DecryptFinal) then
    Result := _EVP_DecryptFinal(ctx, outm, outlen)
  else
    Result := -1;
end;

function EVP_MD_CTX_new: PEVP_MD_CTX;
begin
  if InitSSLInterface and Assigned(_EVP_MD_CTX_new) then
    Result := _EVP_MD_CTX_new
  else
    Result := Nil;
end;

function EVP_MD_CTX_create: PEVP_MD_CTX;
begin
  if InitSSLInterface and Assigned(_EVP_MD_CTX_new) then
    Result := _EVP_MD_CTX_new
  else
    Result := Nil;
end;

procedure EVP_MD_CTX_destroy(ctx: PEVP_MD_CTX);
begin
  EVP_MD_CTX_free(ctx);
end;

procedure EVP_MD_CTX_free(ctx: PEVP_MD_CTX);
begin
  if InitSSLInterface and Assigned(_EVP_MD_CTX_free) then
    _EVP_MD_CTX_free(ctx)
end;

function EVP_PKEY_CTX_new(pkey: PEVP_PKEY; e: PENGINE): PEVP_PKEY_CTX;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_CTX_new) then
    Result := _EVP_PKEY_CTX_new(pkey, e)
  else
    Result := Nil;
end;

procedure EVP_PKEY_CTX_free(ctx: PEVP_PKEY_CTX);
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_CTX_free) then
    _EVP_PKEY_CTX_free(ctx);
end;

function EVP_PKEY_CTX_ctrl(ctx: PEVP_PKEY_CTX; keytype: cint; optype: cint;
  cmd: cint; p1: cint; p2: Pointer): cint;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_CTX_ctrl) then
    Result := _EVP_PKEY_CTX_ctrl(ctx, keytype, optype, cmd, p1, p2)
  else
    Result := -1;
end;

function EVP_PKEY_CTX_set_rsa_padding(ctx: PEVP_PKEY_CTX; pad: cint): cint;
begin
  Result := RSA_pkey_ctx_ctrl(ctx, -1, EVP_PKEY_CTRL_RSA_PADDING, pad, nil);
end;

function EVP_PKEY_CTX_set_rsa_oaep_md(ctx: PEVP_PKEY_CTX; const md: PEVP_MD): cint;
begin
  Result := EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, EVP_PKEY_OP_TYPE_CRYPT, EVP_PKEY_CTRL_RSA_OAEP_MD, 0, md );
end;

function EVP_PKEY_CTX_set_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; const md: PEVP_MD): cint;
begin
  Result := RSA_pkey_ctx_ctrl(ctx, EVP_PKEY_OP_TYPE_SIG or EVP_PKEY_OP_TYPE_CRYPT, EVP_PKEY_CTRL_RSA_MGF1_MD,  0,  md);
end;

function EVP_PKEY_encrypt_init(ctx: PEVP_PKEY_CTX): cint;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_encrypt_init) then
    Result := _EVP_PKEY_encrypt_init(ctx)
  else
    Result := -1;
end;

function EVP_PKEY_encrypt(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint;
  const in_data: PByte; inlen: csize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_encrypt) then
    Result := _EVP_PKEY_encrypt(ctx, out_data, outlen, in_data, inlen)
  else
    Result := -1;
end;

function EVP_PKEY_decrypt_init(ctx: PEVP_PKEY_CTX): cint;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_decrypt_init) then
    Result := _EVP_PKEY_decrypt_init(ctx)
  else
    Result := -1;
end;

function EVP_PKEY_decrypt(ctx: PEVP_PKEY_CTX; out_data: PByte; outlen: pcint;
  const in_data: PByte; inlen: csize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_PKEY_decrypt) then
    Result := _EVP_PKEY_decrypt(ctx, out_data, outlen, in_data, inlen)
  else
    Result := -1;
end;

function EVP_DigestSignInit(ctx: PEVP_MD_CTX; pctx: PPEVP_PKEY_CTX; const evptype: PEVP_MD; e: PENGINE; pkey: PEVP_PKEY): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestSignInit) then
    Result := _EVP_DigestSignInit(ctx, pctx, evptype, e, pkey)
  else
    Result := -1;
end;

function EVP_DigestSignUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
begin
  Result := EVP_DigestUpdate(ctx, data, cnt);
end;

function EVP_DigestSignFinal(ctx: PEVP_MD_CTX; sigret: PByte; siglen: pcsize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestSignFinal) then
    Result := _EVP_DigestSignFinal(ctx, sigret, siglen)
  else
    Result := -1;
end;

function EVP_DigestVerifyInit(ctx: PEVP_MD_CTX; pctx: PPEVP_PKEY_CTX; const evptype: PEVP_MD; e: PENGINE; pkey: PEVP_PKEY): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestVerifyInit) then
    Result := _EVP_DigestVerifyInit(ctx, pctx, evptype, e, pkey)
  else
    Result := -1;
end;

function EVP_DigestVerifyUpdate(ctx: PEVP_MD_CTX; const data: Pointer; cnt: csize_t): cint;
begin
  Result := EVP_DigestUpdate(ctx, data, cnt);
end;

function EVP_DigestVerifyFinal(ctx: PEVP_MD_CTX; sig: PByte; siglen: csize_t): cint;
begin
  if InitSSLInterface and Assigned(_EVP_DigestVerifyFinal) then
    Result := _EVP_DigestVerifyFinal(ctx, sig, siglen)
  else
    Result := -1;
end;

{ PEM }

function PEM_read_bio_PrivateKey(bp: PBIO; X: PPEVP_PKEY;
         cb: Ppem_password_cb; u: Pointer): PEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_PrivateKey) then
    Result := _PEM_read_bio_PrivateKey(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_read_bio_PUBKEY(bp: pBIO; var x: pEVP_PKEY;
               cb: Ppem_password_cb; u: pointer): pEVP_PKEY;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_PUBKEY) then
    Result := _PEM_read_bio_PUBKEY(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_write_bio_PrivateKey(bp: pBIO; x: pEVP_PKEY;
  const enc: pEVP_CIPHER; kstr: PAnsiChar; klen: Integer; cb: Ppem_password_cb;
  u: pointer): integer;
Begin
   if InitSSLInterface and Assigned(_PEM_write_bio_PrivateKey) then
    Result := _PEM_write_bio_PrivateKey(bp, x, enc ,kstr ,klen ,cb, u)
  else
    Result := -1;
end;

function PEM_write_bio_PUBKEY(bp: pBIO; x: pEVP_PKEY): integer;
Begin
   if InitSSLInterface and Assigned(_PEM_write_bio_PUBKEY) then
    Result := _PEM_write_bio_PUBKEY(bp, x)
  else
    Result := -1;
end;

function PEM_read_bio_X509(bp: PBIO; x: PPX509; cb: ppem_password_cb; u: pointer): PX509;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_X509) then
    Result := _PEM_read_bio_X509(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_write_bio_X509(bp: pBIO;  x: px509): integer;
begin
  if InitSSLInterface and Assigned(_PEM_write_bio_X509) then
    Result := _PEM_write_bio_X509(bp, x)
  else
    Result := 0;
end;

function PEM_write_bio_X509_REQ(bp: pBIO; x: PX509_REQ): integer;
begin
  if InitSSLInterface and Assigned(_PEM_write_bio_X509_REQ) then
    Result := _PEM_write_bio_X509_REQ(bp, x)
  else
    Result := 0;
end;

function PEM_write_bio_PKCS7(bp : PBIO; x : PPKCS7) : cint;

begin
  if InitSSLInterface and Assigned(_PEM_write_bio_PKCS7) then
    Result := _PEM_write_bio_PKCS7(bp, x)
  else
    Result := 0;
end;

function PEM_read_bio_RSAPrivateKey(bp : pBIO ; var x : pRSA ;
   cb : Ppem_password_cb ; u : pointer) : pRSA ;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_RSAPrivateKey) then
    Result := _PEM_read_bio_RSAPrivateKey(bp, x, cb, u)
  else
    Result := nil;
end;

function PEM_write_bio_RSAPrivateKey(bp: pBIO; x: pRSA; const enc: pEVP_CIPHER;
  kstr: PAnsiChar; klen: integer; cb: Ppem_password_cb; u: pointer): integer;
begin
  if InitSSLInterface and Assigned(_PEM_write_bio_RSAPrivateKey) then
    Result := _PEM_write_bio_RSAPrivateKey(bp, x, enc, kstr, klen, cb, u )
  else
    Result := -1;
end;

function PEM_read_bio_RSAPublicKey(bp : pBIO ; var x : pRSA ;
   cb : Ppem_password_cb ; u : pointer) : pRSA ;
begin
  if InitSSLInterface and Assigned(_PEM_read_bio_RSAPublicKey) then
    Result := _PEM_read_bio_RSAPublicKey(bp, x, cb, u )
  else
    Result := nil;
end;

function PEM_write_bio_RSAPublicKey(bp : pBIO ; x : pRSA) : integer ;
begin
  if InitSSLInterface and Assigned(_PEM_write_bio_RSAPublicKey) then
    Result := _PEM_write_bio_RSAPublicKey(bp, x )
  else
    Result := -1;
end;

// BIO Functions

function BIO_ctrl(bp: PBIO; cmd: cint; larg: clong; parg: Pointer): clong;
begin
  if InitSSLInterface and Assigned(_BIO_ctrl) then
    Result := _BIO_ctrl(bp, cmd, larg, parg)
  else
    Result := -1;
end;

function BIO_read_filename(b: PBIO; const name: PAnsiChar): cint;
begin
  Result := BIO_ctrl(b, BIO_C_SET_FILENAME, BIO_CLOSE or BIO_FP_READ, name);
end;

function BIO_s_file: pBIO_METHOD;
begin
  if InitSSLInterface and Assigned(_BIO_s_file) then
    Result := _BIO_s_file
  else
    Result := nil;
end;

function BIO_new_file(const filename: PAnsiChar; const mode: PAnsiChar): pBIO;
begin
  if InitSSLInterface and Assigned(_BIO_new_file) then
    Result := _BIO_new_file(filename, mode)
  else
    Result := nil;
end;

function BIO_new_mem_buf(buf: pointer; len: integer): pBIO;
begin
  if InitSSLInterface and Assigned(_BIO_new_mem_buf) then
    Result := _BIO_new_mem_buf(buf, len)
  else
    Result := nil;
end;

// PKCS7 Functions


function PKCS7_ISSUER_AND_SERIAL_new : PPKCS7_ISSUER_AND_SERIAL;

begin
  if InitSSLInterface and Assigned(_PKCS7_ISSUER_AND_SERIAL_new) then
    Result := _PKCS7_ISSUER_AND_SERIAL_new
  else
    Result := nil;
end;

procedure PKCS7_ISSUER_AND_SERIAL_free (a:PPKCS7_ISSUER_AND_SERIAL);
begin
  if InitSSLInterface and Assigned(_PKCS7_ISSUER_AND_SERIAL_free) then
    _PKCS7_ISSUER_AND_SERIAL_free(a)
end;

function PKCS7_ISSUER_AND_SERIAL_digest(data:PPKCS7_ISSUER_AND_SERIAL; _type:PEVP_MD; md:Pbyte; len:Pdword):longint;
begin
  if InitSSLInterface and Assigned(_PKCS7_ISSUER_AND_SERIAL_digest) then
    Result:=_PKCS7_ISSUER_AND_SERIAL_digest(data,_type,md,len)
  else
    Result:=-1;
end;

function PKCS7_dup(p7:PPKCS7):PPKCS7;
begin
  if InitSSLInterface and Assigned(_PKCS7_dup) then
    Result:=_PKCS7_dup(p7)
  else
    Result:=Nil;
end;

function PEM_write_bio_PKCS7_stream(_out:PBIO; p7:PPKCS7; _in:PBIO; flags:longint):longint;

begin
  if InitSSLInterface and Assigned(_PEM_write_bio_PKCS7_stream) then
    Result:=_PEM_write_bio_PKCS7_stream(_out,p7,_in,flags)
  else
    Result:=-1;
end;

function PKCS7_SIGNER_INFO_new:PPKCS7_SIGNER_INFO;

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNER_INFO_new) then
    Result:=_PKCS7_SIGNER_INFO_new
  else
    Result:=Nil;
end;

procedure PKCS7_SIGNER_INFO_free(a:PPKCS7_SIGNER_INFO);

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNER_INFO_free) then
    _PKCS7_SIGNER_INFO_free(a);
end;


function PKCS7_RECIP_INFO_new:PPKCS7_RECIP_INFO;

begin
  if InitSSLInterface and Assigned(_PKCS7_RECIP_INFO_new) then
    Result:=_PKCS7_RECIP_INFO_new
  else
    Result:=Nil;
end;

procedure PKCS7_RECIP_INFO_free(a:PPKCS7_RECIP_INFO);

begin
  if InitSSLInterface and Assigned(_PKCS7_RECIP_INFO_free) then
    _PKCS7_RECIP_INFO_free(a);
end;


function PKCS7_SIGNED_new:PPKCS7_SIGNED;

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNED_new) then
    Result:=_PKCS7_SIGNED_new
  else
    Result:=Nil;
end;

procedure PKCS7_SIGNED_free(a:PPKCS7_SIGNED);

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNED_free) then
    _PKCS7_SIGNED_free(a)
end;


function PKCS7_ENC_CONTENT_new:PPKCS7_ENC_CONTENT;

begin
  if InitSSLInterface and Assigned(_PKCS7_ENC_CONTENT_new) then
    Result:=_PKCS7_ENC_CONTENT_new
  else
    Result:=Nil;
end;

procedure PKCS7_ENC_CONTENT_free(a:PPKCS7_ENC_CONTENT);

begin
  if InitSSLInterface and Assigned(_PKCS7_ENC_CONTENT_free) then
    _PKCS7_ENC_CONTENT_free(a)
end;


function PKCS7_ENVELOPE_new:PPKCS7_ENVELOPE;

begin
  if InitSSLInterface and Assigned(_PKCS7_ENVELOPE_new) then
    Result:=_PKCS7_ENVELOPE_new
  else
    Result:=Nil;
end;

procedure PKCS7_ENVELOPE_free(a:PPKCS7_ENVELOPE);

begin
  if InitSSLInterface and Assigned(_PKCS7_ENVELOPE_free) then
    _PKCS7_ENVELOPE_free(a)
end;


function PKCS7_SIGN_ENVELOPE_new:PPKCS7_SIGN_ENVELOPE;

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGN_ENVELOPE_new) then
    Result:=_PKCS7_SIGN_ENVELOPE_new
  else
    Result:=Nil;
end;

procedure PKCS7_SIGN_ENVELOPE_free(a:PPKCS7_SIGN_ENVELOPE);

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGN_ENVELOPE_free) then
    _PKCS7_SIGN_ENVELOPE_free(a)
end;


function PKCS7_DIGEST_new:PPKCS7_DIGEST;

begin
  if InitSSLInterface and Assigned(_PKCS7_DIGEST_new) then
    Result:=_PKCS7_DIGEST_new
  else
    Result:=Nil;
end;

procedure PKCS7_DIGEST_free(a:PPKCS7_DIGEST);

begin
  if InitSSLInterface and Assigned(_PKCS7_DIGEST_free) then
    _PKCS7_DIGEST_free(a)
end;


function PKCS7_ENCRYPT_new:PPKCS7_ENCRYPT;

begin
  if InitSSLInterface and Assigned(_PKCS7_ENCRYPT_new) then
    Result:=_PKCS7_ENCRYPT_new
  else
    Result:=Nil;
end;

procedure PKCS7_ENCRYPT_free(a:PPKCS7_ENCRYPT);

begin
  if InitSSLInterface and Assigned(_PKCS7_ENCRYPT_free) then
    _PKCS7_ENCRYPT_free(a)
end;


function PKCS7_new:PPKCS7;

begin
  if InitSSLInterface and Assigned(_PKCS7_new) then
    Result:=_PKCS7_new
  else
    Result:=Nil;
end;

procedure PKCS7_free(a:PPKCS7);

begin
  if InitSSLInterface and Assigned(_PKCS7_free) then
    _PKCS7_free(a)
end;


function PKCS7_print_ctx(_out:PBIO; x:PPKCS7; indent:longint; pctx:Pointer):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_print_ctx) then
    Result:=PKCS7_print_ctx(_out,x,indent,pctx)
  else
    Result:=-1;
end;

function PKCS7_ctrl(p7: PPKCS7; cmd: longint; larg: longint; parg: PAnsiChar
  ): longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_ctrl) then
    Result:=_PKCS7_ctrl(p7,cmd,larg,parg)
  else
    Result:=-1;
end;

function PKCS7_set_type(p7:PPKCS7; _type:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_type) then
    Result:=_PKCS7_set_type(p7,_type)
  else
    Result:=-1;
end;

function PKCS7_set0_type_other(p7:PPKCS7; _type:longint; other:PASN1_TYPE):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set0_type_other) then
    Result:=_PKCS7_set0_type_other(p7,_type,other)
  else
    Result:=-1;
end;

function PKCS7_set_content(p7:PPKCS7; p7_data:PPKCS7):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_content) then
    Result:=_PKCS7_set_content(p7,p7_Data)
  else
    Result:=-1;
end;

function PKCS7_SIGNER_INFO_set(p7i:PPKCS7_SIGNER_INFO; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNER_INFO_set) then
    Result:=_PKCS7_SIGNER_INFO_set(p7i,x509,pkey,dgst)
  else
    Result:=-1;
end;

function PKCS7_SIGNER_INFO_sign(si:PPKCS7_SIGNER_INFO):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_SIGNER_INFO_sign) then
    Result:=_PKCS7_SIGNER_INFO_sign(si)
  else
    Result:=-1;
end;

function PKCS7_add_signer(p7:PPKCS7; p7i:PPKCS7_SIGNER_INFO):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_signer) then
    Result:=_PKCS7_add_signer(p7,p7i)
  else
    Result:=-1;
end;

function PKCS7_add_certificate(p7:PPKCS7; x509:PX509):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_certificate) then
    Result:=_PKCS7_add_certificate(p7,x509)
  else
    Result:=-1;
end;

function PKCS7_add_crl(p7:PPKCS7; x509: Pointer):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_crl) then
    Result:=PKCS7_add_crl(p7,x509)
  else
    Result:=-1;
end;

function PKCS7_content_new(p7:PPKCS7; nid:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_content_new) then
    Result:=_PKCS7_content_new(p7,nid)
  else
    Result:=-1;
end;

function PKCS7_add_signature(p7:PPKCS7; x509:PX509; pkey:PEVP_PKEY; dgst:PEVP_MD):PPKCS7_SIGNER_INFO;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_signature) then
    Result:=PKCS7_add_signature(p7,x509,pkey,dgst)
  else
    Result:=Nil;
end;

function PKCS7_cert_from_signer_info(p7:PPKCS7; si:PPKCS7_SIGNER_INFO):PX509;

begin
  if InitSSLInterface and Assigned(_PKCS7_cert_from_signer_info) then
    Result:=_PKCS7_cert_from_signer_info(p7,si)
  else
    Result:=Nil;
end;

function PKCS7_set_digest(p7:PPKCS7; md:PEVP_MD):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_digest) then
    Result:=_PKCS7_set_digest(p7,md)
  else
    Result:=-1;
end;

function PKCS7_add_recipient(p7:PPKCS7; x509:PX509):PPKCS7_RECIP_INFO;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_recipient) then
    Result:=_PKCS7_add_recipient(p7,x509)
  else
    Result:=Nil;
end;

function PKCS7_add_recipient_info(p7:PPKCS7; ri:PPKCS7_RECIP_INFO):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_recipient_info) then
    Result:=_PKCS7_add_recipient_info(p7,ri)
  else
    Result:=-1;
end;

function PKCS7_RECIP_INFO_set(p7i:PPKCS7_RECIP_INFO; x509:PX509):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_RECIP_INFO_set) then
    Result:=_PKCS7_RECIP_INFO_set(p7i,x509)
  else
    Result:=-1;
end;

function PKCS7_set_cipher(p7:PPKCS7; cipher:PEVP_CIPHER):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_cipher) then
    Result:=_PKCS7_set_cipher(p7,cipher)
  else
    Result:=-1;
end;

function PKCS7_get_issuer_and_serial(p7:PPKCS7; idx:longint):PPKCS7_ISSUER_AND_SERIAL;

begin
  if InitSSLInterface and Assigned(_PKCS7_get_issuer_and_serial) then
    Result:=_PKCS7_get_issuer_and_serial(P7,idx)
  else
    Result:=Nil;
end;

function PKCS7_digest_from_attributes(sk:Pstack_st_X509_ATTRIBUTE):Pointer;

begin
  if InitSSLInterface and Assigned(_PKCS7_digest_from_attributes) then
    Result:=_PKCS7_digest_from_attributes(sk)
  else
    Result:=Nil;
end;

function PKCS7_add_signed_attribute(p7si:PPKCS7_SIGNER_INFO; nid:longint; _type:longint; data:pointer):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_signed_attribute) then
    Result:=_PKCS7_add_signed_attribute(p7si,nid,_type,data)
  else
    Result:=-1;
end;

function PKCS7_add_attribute(p7si:PPKCS7_SIGNER_INFO; nid:longint; atrtype:longint; value:pointer):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_attribute) then
    Result:=_PKCS7_add_attribute(p7si,nid,atrtype,value)
  else
    Result:=-1;
end;

function PKCS7_get_attribute(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;

begin
  if InitSSLInterface and Assigned(_PKCS7_get_attribute) then
    Result:=_PKCS7_get_attribute(si,nid)
  else
    Result:=Nil;
end;

function PKCS7_get_signed_attribute(si:PPKCS7_SIGNER_INFO; nid:longint):PASN1_TYPE;

begin
  if InitSSLInterface and Assigned(_PKCS7_get_signed_attribute) then
    Result:=_PKCS7_get_signed_attribute(si,nid)
  else
    Result:=Nil;
end;

function PKCS7_set_signed_attributes(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_signed_attributes) then
    Result:=_PKCS7_set_signed_attributes(p7si,sk)
  else
    Result:=-1;
end;

function PKCS7_set_attributes(p7si:PPKCS7_SIGNER_INFO; sk:Pstack_st_X509_ATTRIBUTE):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_set_attributes) then
    Result:=_PKCS7_set_attributes(p7si,sk)
  else
    Result:=-1;
end;

function PKCS7_sign(signcert:PX509; pkey:PEVP_PKEY; certs:Pstack_st_X509; data:PBIO; flags:longint):PPKCS7;

begin
  if InitSSLInterface and Assigned(_PKCS7_sign) then
    Result:=_PKCS7_sign(signcert,pkey,certs,data,flags)
  else
    Result:=Nil;
end;

function PKCS7_sign_add_signer(p7:PPKCS7; signcert:PX509; pkey:PEVP_PKEY; md:PEVP_MD; flags:longint):PPKCS7_SIGNER_INFO;

begin
  if InitSSLInterface and Assigned(_PKCS7_sign_add_signer) then
    Result:=_PKCS7_sign_add_signer(p7,signcert,pkey,md,flags)
  else
    Result:=Nil;
end;

function PKCS7_final(p7:PPKCS7; data:PBIO; flags:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_final) then
    Result:=_PKCS7_final(p7,data,Flags)
  else
    Result:=-1;
end;

function PKCS7_verify(p7:PPKCS7; certs:Pstack_st_X509; store: Pointer; indata:PBIO; _out:PBIO;  flags:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_verify) then
    Result:=_PKCS7_verify(p7,certs,store,indata,_out,flags)
  else
    Result:=-1;
end;

function PKCS7_encrypt(certs:Pstack_st_X509; _in:PBIO; cipher:PEVP_CIPHER; flags:longint):PPKCS7;

begin
  if InitSSLInterface and Assigned(_PKCS7_encrypt) then
    Result:=_PKCS7_encrypt(certs,_in,cipher,flags)
  else
    Result:=Nil;
end;

function PKCS7_decrypt(p7:PPKCS7; pkey:PEVP_PKEY; cert:PX509; data:PBIO; flags:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_decrypt) then
    Result:=_PKCS7_decrypt(P7,pkey,cert,data,flags)
  else
    Result:=-1;
end;

function PKCS7_add_attrib_smimecap(si:PPKCS7_SIGNER_INFO; cap:Pstack_st_X509_ALGOR):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_attrib_smimecap) then
    Result:=_PKCS7_add_attrib_smimecap(si,cap)
  else
    Result:=-1;
end;

function PKCS7_simple_smimecap(sk:Pstack_st_X509_ALGOR; nid:longint; arg:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_simple_smimecap) then
    Result:=_PKCS7_simple_smimecap(sk,nid,arg)
  else
    Result:=-1;
end;

function PKCS7_add_attrib_content_type(si:PPKCS7_SIGNER_INFO; coid:Pointer):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add_attrib_content_type) then
    Result:=_PKCS7_add_attrib_content_type(si,coid)
  else
    Result:=-1;
end;

function PKCS7_add0_attrib_signing_time(si:PPKCS7_SIGNER_INFO; t:PASN1_TIME):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add0_attrib_signing_time) then
    Result:=_PKCS7_add0_attrib_signing_time(si,t)
  else
    Result:=-1;
end;

function PKCS7_add1_attrib_digest(si:PPKCS7_SIGNER_INFO; md:Pbyte; mdlen:longint):longint;

begin
  if InitSSLInterface and Assigned(_PKCS7_add1_attrib_digest) then
    Result:=_PKCS7_add1_attrib_digest(si,md,mdlen)
  else
    Result:=-1;
end;

function BIO_new_PKCS7(_out:PBIO; p7:PPKCS7):PBIO;

begin
  if InitSSLInterface and Assigned(_BIO_new_PKCS7) then
    Result:=_BIO_new_PKCS7(_out,p7)
  else
    Result:=Nil;
end;

procedure ERR_load_PKCS7_strings;

begin
  if InitSSLInterface and Assigned(_ERR_load_PKCS7_strings) then
    _ERR_load_PKCS7_strings
end;

// BN

function BN_new: PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BN_new) then
    Result:=_BN_new()
  else
    Result:=Nil;
end;

function BN_secure_new: PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BIO_new_PKCS7) then
    Result:=_BN_secure_new()
  else
    Result:=Nil;
end;

procedure BN_clear_free(a: PBIGNUM);
begin
  if InitSSLInterface and Assigned(_BN_clear_free) then
    _BN_clear_free(a)
end;

function BN_copy(a: PBIGNUM; b: PBIGNUM): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BN_copy) then
    Result:=_BN_copy(a, b)
  else
    Result:=Nil;
end;

procedure BN_swap(a: PBIGNUM; b: PBIGNUM);
begin
  if InitSSLInterface and Assigned(_BN_swap) then
    _BN_swap(a, b);
end;

function BN_print(fp : pBIO ; const a : PBIGNUM) : cint ;
begin
  if InitSSLInterface and Assigned(_BN_print) then
    Result := _BN_print(fp, a)
  else
    Result := -1;
end;

function BN_bin2bn(s: pcuchar; len: cint; ret: PBIGNUM): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BN_bin2bn) then
    Result:=_BN_bin2bn(s, len, ret)
  else
    Result:=Nil;
end;

function BN_hex2bn(var n: PBIGNUM; const str: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_BN_hex2bn) then
    Result := _BN_hex2bn(n, str)
  else
    Result := -1;
end;

function BN_dec2bn(var n: PBIGNUM; const str: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_BN_dec2bn) then
    Result := _BN_dec2bn(n, str)
  else
    Result := -1;
end;

function BN_bn2hex(const n: PBIGNUM): PAnsiChar;
begin
  if InitSSLInterface and Assigned(_BN_bn2hex) then
    Result := _BN_bn2hex(n)
  else
    Result := Nil;
end;

function BN_bn2dec(const n: PBIGNUM): PAnsiChar;
begin
  if InitSSLInterface and Assigned(_BN_bn2dec) then
    Result := _BN_bn2dec(n)
  else
    Result := Nil;
end;

function BN_bn2bin(a: PBIGNUM; _to: pcuchar): cint;
begin
  if InitSSLInterface and Assigned(_BN_bn2bin) then
    Result:=_BN_bn2bin(a, _to)
  else
    Result:=-1;
end;

function BN_bn2binpad(a: PBIGNUM; _to: pcuchar; tolen: cint): cint;
begin
  if InitSSLInterface and Assigned(_BN_bn2binpad) then
    Result:=_BN_bn2binpad(a, _to, tolen)
  else
    Result:=-1;
end;

function BN_lebin2bn(s: pcuchar; len: cint; ret: PBIGNUM): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BN_lebin2bn) then
    Result:=_BN_lebin2bn(s, len, ret)
  else
    Result:=Nil;
end;

function BN_bn2lebinpad(a: PBIGNUM; _to: pcuchar; tolen: cint): cint;
begin
  if InitSSLInterface and Assigned(_BN_bn2lebinpad) then
    Result:=_BN_bn2lebinpad(a, _to, tolen)
  else
    Result:=-1;
end;

function BN_mpi2bn(s: pcuchar; len: cint; ret: PBIGNUM): PBIGNUM;
begin
  if InitSSLInterface and Assigned(_BN_mpi2bn) then
    Result:=_BN_mpi2bn(s, len, ret)
  else
    Result:=Nil;
end;

function BN_bn2mpi(a: PBIGNUM; _to: pcuchar): cint;
begin
  if InitSSLInterface and Assigned(_BN_bn2mpi) then
    Result:=_BN_bn2mpi(a, _to)
  else
    Result:=-1;
end;

function BN_sub(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_sub) then
    Result:=_BN_sub(r, a, b)
  else
    Result:=-1;
end;

function BN_usub(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_usub) then
    Result:=_BN_usub(r, a, b)
  else
    Result:=-1;
end;

function BN_uadd(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_uadd) then
    Result:=_BN_uadd(r, a, b)
  else
    Result:=-1;
end;

function BN_add(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_add) then
    Result:=_BN_add(r, a, b)
  else
    Result:=-1;
end;

function BN_mul(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mul) then
    Result:=_BN_mul(r, a, b, ctx)
  else
    Result:=-1;
end;

function BN_sqr(r: PBIGNUM; a: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_sqr) then
    Result:=_BN_sqr(r, a, ctx)
  else
    Result:=-1;
end;

procedure BN_set_negative(b: PBIGNUM; n: cint);
begin
  if InitSSLInterface and Assigned(_BN_set_negative) then
    _BN_set_negative(b, n);
end;

function BN_is_negative(b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_is_negative) then
    Result:=_BN_is_negative(b)
  else
    Result:=-1;
end;

function BN_div(dv: PBIGNUM; rem: PBIGNUM; m: PBIGNUM; d: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_div) then
    Result:=_BN_div(dv, rem, m, d, ctx)
  else
    Result:=-1;
end;

function BN_mod(rem: PBIGNUM; a: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod) then
    Result:=_BN_mod(rem, a, m, ctx)
  else
    Result:=-1;
end;

function BN_nnmod(r: PBIGNUM; m: PBIGNUM; d: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_nnmod) then
    Result:=_BN_nnmod(r, m, d, ctx)
  else
    Result:=-1;
end;

function BN_mod_add(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_add) then
    Result:=_BN_mod_add(r, a, b, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_add_quick(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; m: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_add_quick) then
    Result:=_BN_mod_add_quick(r, a, b, m)
  else
    Result:=-1;
end;

function BN_mod_sub(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_sub) then
    Result:=_BN_mod_sub(r, a, b, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_sub_quick(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; m: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_sub_quick) then
    Result:=_BN_mod_sub_quick(r, a, b, m)
  else
    Result:=-1;
end;

function BN_mod_mul(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_mul) then
    Result:=_BN_mod_mul(r, a, b, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_sqr(r: PBIGNUM; a: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_sqr) then
    Result:=_BN_mod_sqr(r, a, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_lshift1(r: PBIGNUM; a: PBIGNUM; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_lshift1) then
    Result:=_BN_mod_lshift1(r, a, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_lshift1_quick(r: PBIGNUM; a: PBIGNUM; m: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_lshift1_quick) then
    Result:=_BN_mod_lshift1_quick(r, a, m)
  else
    Result:=-1;
end;

function BN_mod_lshift(r: PBIGNUM; a: PBIGNUM; n: cint; m: PBIGNUM; ctx: PBN_CTX): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_lshift) then
    Result:=_BN_mod_lshift(r, a, n, m, ctx)
  else
    Result:=-1;
end;

function BN_mod_lshift_quick(r: PBIGNUM; a: PBIGNUM; n: cint; m: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_mod_lshift_quick) then
    Result:=_BN_mod_lshift_quick(r, a, n, m)
  else
    Result:=-1;
end;

function BN_mod_word(a: PBIGNUM; w: BN_ULONG): BN_ULONG;
begin
  if InitSSLInterface and Assigned(_BN_mod_word) then
    Result:=_BN_mod_word(a, w)
  else
    Result:=0;
end;

function BN_div_word(a: PBIGNUM; w: BN_ULONG): BN_ULONG;
begin
  if InitSSLInterface and Assigned(_BN_div_word) then
    Result:=_BN_div_word(a, w)
  else
    Result:=0;
end;

function BN_mul_word(a: PBIGNUM; w: BN_ULONG): cint;
begin
  if InitSSLInterface and Assigned(_BN_mul_word) then
    Result:=_BN_mul_word(a, w)
  else
    Result:=-1;
end;

function BN_add_word(a: PBIGNUM; w: BN_ULONG): cint;
begin
  if InitSSLInterface and Assigned(_BN_add_word) then
    Result:=_BN_add_word(a, w)
  else
    Result:=-1;
end;

function BN_sub_word(a: PBIGNUM; w: BN_ULONG): cint;
begin
  if InitSSLInterface and Assigned(_BN_sub_word) then
    Result:=_BN_sub_word(a, w)
  else
    Result:=-1;
end;

function BN_set_word(a: PBIGNUM; w: BN_ULONG): cint;
begin
  if InitSSLInterface and Assigned(_BN_set_word) then
    Result:=_BN_set_word(a, w)
  else
    Result:=-1;
end;

function BN_get_word(a: PBIGNUM): BN_ULONG;
begin
  if InitSSLInterface and Assigned(_BN_get_word) then
    Result:=_BN_get_word(a)
  else
    Result:=0;
end;

function BN_cmp(a: PBIGNUM; b: PBIGNUM): cint;
begin
  if InitSSLInterface and Assigned(_BN_cmp) then
    Result:=_BN_cmp(a, b)
  else
    Result:=-1;
end;

procedure BN_free(a: PBIGNUM);
begin
  if InitSSLInterface and Assigned(_BN_free) then
    _BN_free(a);
end;

procedure CRYPTOcleanupAllExData;
begin
  if InitSSLInterface and Assigned(_CRYPTOcleanupAllExData) then
    _CRYPTOcleanupAllExData;
end;

procedure OPENSSLaddallalgorithms;
begin
  if InitSSLInterface and Assigned(_OPENSSLaddallalgorithms) then
    _OPENSSLaddallalgorithms;
end;

function OSSL_LIB_CTX_get0_global_default: POSSL_LIB_CTX;
begin
  if InitSSLInterface and Assigned(_OSSL_LIB_CTX_get0_global_default) then
    Result := _OSSL_LIB_CTX_get0_global_default
  else
    Result := Nil;
end;

function OSSL_PROVIDER_available(libctx: POSSL_LIB_CTX; name: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_OSSL_PROVIDER_available) then
    Result := _OSSL_PROVIDER_available(libctx, name)
  else
    Result := -1;
end;

function OSSL_PROVIDER_load(libctx: POSSL_LIB_CTX; name: PAnsiChar
  ): POSSL_PROVIDER;
begin
  if InitSSLInterface and Assigned(_OSSL_PROVIDER_load) then
    Result := _OSSL_PROVIDER_load(libctx, name)
  else
    Result := Nil;
end;

function OSSL_PROVIDER_unload(prov: POSSL_PROVIDER): cint;
begin
  if InitSSLInterface and Assigned(_OSSL_PROVIDER_unload) then
    Result := _OSSL_PROVIDER_unload(prov)
  else
    Result := -1;
end;

function OSSL_PROVIDER_set_default_search_path(libctx: POSSL_LIB_CTX;
  const path: PAnsiChar): cint;
begin
  if InitSSLInterface and Assigned(_OSSL_PROVIDER_set_default_search_path) then
    Result := _OSSL_PROVIDER_set_default_search_path(libctx, path)
  else
    Result := -1;
end;


function LoadLib(const Value: String): HModule;
begin
 if (SSLLibPath <> '') then
 begin
   if (RightStr(SSLLibPath, Length(PathDelim)) <> PathDelim) then
     SSLLibPath := SSLLibPath + PathDelim;
 end;

 {$IfDef FPC}
  Result := dynlibs.LoadLibrary(SSLLibPath + Value) ;
 {$Else}
  Result := LoadLibrary(PChar(SSLLibPath + Value));
 {$ENDIF}
end;

function GetProcAddr(module: HModule; const ProcName: string): SslPtr;
begin
  Result := GetProcAddress(module, PChar(ProcName));
  if LoadVerbose and (Result = nil) then
    OpenSSL_unavailable_functions := OpenSSL_unavailable_functions + ProcName + LineEnding;
end;

// The AVerboseLoading parameter can be used to check which particular
// functions weren't loaded correctly. They will be available in the
// global variable OpenSSL_unavailable_functions

function IsSSLloaded: Boolean;

begin
  Result := SSLLoaded;
end;

Procedure LoadSSLEntryPoints;
begin
  _SslGetError := GetProcAddr(SSLLibHandle, 'SSL_get_error');
  _SslLibraryInit := GetProcAddr(SSLLibHandle, 'SSL_library_init');
  _SslLoadErrorStrings := GetProcAddr(SSLLibHandle, 'SSL_load_error_strings');
  _SslCtxSetCipherList := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_cipher_list');
  _SslCtxNew := GetProcAddr(SSLLibHandle, 'SSL_CTX_new');
  _SslCtxFree := GetProcAddr(SSLLibHandle, 'SSL_CTX_free');
  _SslSetFd := GetProcAddr(SSLLibHandle, 'SSL_set_fd');
  _SslCtrl := GetProcAddr(SSLLibHandle, 'SSL_ctrl');
  _SslCTXCtrl := GetProcAddr(SSLLibHandle, 'SSL_CTX_ctrl');
  _SslCtxSetMinProtoVersion := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_min_proto_version');
  _SslCtxSetMaxProtoVersion := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_max_proto_version');
  _SslMethodV2 := GetProcAddr(SSLLibHandle, 'SSLv2_method');
  _SslMethodV3 := GetProcAddr(SSLLibHandle, 'SSLv3_method');
  _SslMethodTLSV1 := GetProcAddr(SSLLibHandle, 'TLSv1_method');
  _SslMethodTLSV1_1 := GetProcAddr(SSLLibHandle, 'TLSv1_1_method');
  _SslMethodTLSV1_2 := GetProcAddr(SSLLibHandle, 'TLSv1_2_method');
  _SslMethodV23 := GetProcAddr(SSLLibHandle, 'SSLv23_method');
  _SslTLSMethod := GetProcAddr(SSLLibHandle, 'TLS_method');
  _SslCtxUsePrivateKey := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_PrivateKey');
  _SslCtxUsePrivateKeyASN1 := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_PrivateKey_ASN1');
  //use SSL_CTX_use_RSAPrivateKey_file instead SSL_CTX_use_PrivateKey_file,
  //because SSL_CTX_use_PrivateKey_file not support DER format. :-O
  _SslCtxUsePrivateKeyFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_RSAPrivateKey_file');
  _SslCtxUseCertificate := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate');
  _SslCtxUseCertificateASN1 := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_ASN1');
  _SslCtxUseCertificateFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_file');
  _SslCtxUseCertificateChainFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_use_certificate_chain_file');
  _SslCtxCheckPrivateKeyFile := GetProcAddr(SSLLibHandle, 'SSL_CTX_check_private_key');
  _SslCtxSetDefaultPasswdCb := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_default_passwd_cb');
  _SslCtxSetDefaultPasswdCbUserdata := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_default_passwd_cb_userdata');
  _SslCtxLoadVerifyLocations := GetProcAddr(SSLLibHandle, 'SSL_CTX_load_verify_locations');
  _SslNew := GetProcAddr(SSLLibHandle, 'SSL_new');
  _SslFree := GetProcAddr(SSLLibHandle, 'SSL_free');
  _SslAccept := GetProcAddr(SSLLibHandle, 'SSL_accept');
  _SslConnect := GetProcAddr(SSLLibHandle, 'SSL_connect');
  _SslShutdown := GetProcAddr(SSLLibHandle, 'SSL_shutdown');
  _SslRead := GetProcAddr(SSLLibHandle, 'SSL_read');
  _SslPeek := GetProcAddr(SSLLibHandle, 'SSL_peek');
  _SslWrite := GetProcAddr(SSLLibHandle, 'SSL_write');
  _SslPending := GetProcAddr(SSLLibHandle, 'SSL_pending');
  _SslGetPeerCertificate := GetProcAddr(SSLLibHandle, 'SSL_get1_peer_certificate');
  if not Assigned(_SslGetPeerCertificate) then
    _SslGetPeerCertificate := GetProcAddr(SSLLibHandle, 'SSL_get_peer_certificate');
  _SslGetVersion := GetProcAddr(SSLLibHandle, 'SSL_get_version');
  _SslCtxSetVerify := GetProcAddr(SSLLibHandle, 'SSL_CTX_set_verify');
  _SslGetCurrentCipher := GetProcAddr(SSLLibHandle, 'SSL_get_current_cipher');
  _SslCipherGetName := GetProcAddr(SSLLibHandle, 'SSL_CIPHER_get_name');
  _SslCipherGetBits := GetProcAddr(SSLLibHandle, 'SSL_CIPHER_get_bits');
  _SslGetVerifyResult := GetProcAddr(SSLLibHandle, 'SSL_get_verify_result');
  _SslGetServername := GetProcAddr(SSLLibHandle, 'SSL_get_servername');
  _SslCtxCallbackCtrl := GetProcAddr(SSLLibHandle, 'SSL_CTX_callback_ctrl');
  _SslSetSslCtx := GetProcAddr(SSLLibHandle, 'SSL_set_SSL_CTX');
end;

Procedure LoadUtilEntryPoints;
begin
  _OpenSSLVersionNum := GetProcAddr(SSLUtilHandle, 'OpenSSL_version_num');
  if not Assigned(_OpenSSLVersionNum) then
    _OpenSSLVersionNum := GetProcAddr(SSLUtilHandle, 'SSLeay');  // Version 1.0.x
  _OpenSSLVersion := GetProcAddr(SSLUtilHandle, 'OpenSSL_version');
  if not Assigned(_OpenSSLVersion) then
    _OpenSSLVersion := GetProcAddr(SSLUtilHandle, 'SSLeay_version');  // Version 1.0.x

  _ERR_load_crypto_strings := GetProcAddr(SSLUtilHandle, 'ERR_load_crypto_strings');
  _X509New := GetProcAddr(SSLUtilHandle, 'X509_new');
  _X509Free := GetProcAddr(SSLUtilHandle, 'X509_free');
  _X509_NAME_new := GetProcAddr(SSLUtilHandle, 'X509_NAME_new');
  _X509_NAME_free := GetProcAddr(SSLUtilHandle, 'X509_NAME_free');
  _X509NameOneline := GetProcAddr(SSLUtilHandle, 'X509_NAME_oneline');
  _X509NAMEprintEx := GetProcAddr(SSLUtilHandle, 'X509_NAME_print_ex');
  _X509GetSubjectName := GetProcAddr(SSLUtilHandle, 'X509_get_subject_name');
  _X509GetIssuerName := GetProcAddr(SSLUtilHandle, 'X509_get_issuer_name');
  _X509NameHash := GetProcAddr(SSLUtilHandle, 'X509_NAME_hash');
  _X509Digest := GetProcAddr(SSLUtilHandle, 'X509_digest');
  _X509print := GetProcAddr(SSLUtilHandle, 'X509_print');
  _X509SetVersion := GetProcAddr(SSLUtilHandle, 'X509_set_version');
  _X509SetPubkey := GetProcAddr(SSLUtilHandle, 'X509_set_pubkey');
  _X509GetPubkey := GetProcAddr(SSLUtilHandle, 'X509_get_pubkey');
  _X509SetIssuerName := GetProcAddr(SSLUtilHandle, 'X509_set_issuer_name');
  _X509NameAddEntryByTxt := GetProcAddr(SSLUtilHandle, 'X509_NAME_add_entry_by_txt');
  _X509Sign := GetProcAddr(SSLUtilHandle, 'X509_sign');
  _X509GmtimeAdj := GetProcAddr(SSLUtilHandle, 'X509_gmtime_adj');
  _X509GetNotBefore := GetProcAddr(SSLUtilHandle, 'X509_get0_notBefore');
  _X509GetNotAfter := GetProcAddr(SSLUtilHandle, 'X509_get0_notAfter');
  _X509SetNotBefore := GetProcAddr(SSLUtilHandle, 'X509_set1_notBefore');
  _X509SetNotAfter := GetProcAddr(SSLUtilHandle, 'X509_set1_notAfter');
  _X509GetSerialNumber := GetProcAddr(SSLUtilHandle, 'X509_get_serialNumber');
  _X509GetExt := GetProcAddr(SSLUtilHandle, 'X509_get_ext');
  _X509ExtensionGetData := GetProcAddr(SSLUtilHandle, 'X509_EXTENSION_get_data');
  _X509_REQ_new := GetProcAddr(SSLUtilHandle, 'X509_REQ_new');
  _X509_REQ_free := GetProcAddr(SSLUtilHandle, 'X509_REQ_free');
  _X509_REQ_set_subject_name := GetProcAddr(SSLUtilHandle, 'X509_REQ_set_subject_name');
  _X509_REQ_set_pubkey := GetProcAddr(SSLUtilHandle, 'X509_REQ_set_pubkey');
  _X509_REQ_sign := GetProcAddr(SSLUtilHandle, 'X509_REQ_sign');
  _EvpPkeyNew := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_new');
  _EvpPkeyFree := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_free');
  _EvpPkeyAssign := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_assign');
  _EvpPkeyGet1RSA := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_get1_RSA');
  _EvpPkeySet1RSA := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_set1_RSA');
  _EVPCleanup := GetProcAddr(SSLUtilHandle, 'EVP_cleanup');
  _EvpGetDigestByName := GetProcAddr(SSLUtilHandle, 'EVP_get_digestbyname');
  _ErrErrorString := GetProcAddr(SSLUtilHandle, 'ERR_error_string_n');
  _ErrGetError := GetProcAddr(SSLUtilHandle, 'ERR_get_error');
  _ErrClearError := GetProcAddr(SSLUtilHandle, 'ERR_clear_error');
  _ErrFreeStrings := GetProcAddr(SSLUtilHandle, 'ERR_free_strings');
  _ErrRemoveState := GetProcAddr(SSLUtilHandle, 'ERR_remove_state');
  _RandScreen := GetProcAddr(SSLUtilHandle, 'RAND_screen');
  _BioNew := GetProcAddr(SSLUtilHandle, 'BIO_new');
  _BioFreeAll := GetProcAddr(SSLUtilHandle, 'BIO_free_all');
  _BioSMem := GetProcAddr(SSLUtilHandle, 'BIO_s_mem');
  _BioCtrlPending := GetProcAddr(SSLUtilHandle, 'BIO_ctrl_pending');
  _BioRead := GetProcAddr(SSLUtilHandle, 'BIO_read');
  _BioWrite := GetProcAddr(SSLUtilHandle, 'BIO_write');
  _BioReset := GetProcAddr(SSLUtilHandle, 'BIO_reset');
  _d2iPKCS12bio := GetProcAddr(SSLUtilHandle, 'd2i_PKCS12_bio');
  _PKCS12parse := GetProcAddr(SSLUtilHandle, 'PKCS12_parse');
  _PKCS12free := GetProcAddr(SSLUtilHandle, 'PKCS12_free');
  _Asn1UtctimeSetString := GetProcAddr(SSLUtilHandle, 'ASN1_UTCTIME_set_string');
  _Asn1StringTypeNew := GetProcAddr(SSLUtilHandle, 'ASN1_STRING_type_new');
  _Asn1UtctimePrint := GetProcAddr(SSLUtilHandle, 'ASN1_UTCTIME_print');
  _Asn1UtctimeFree := GetProcAddr(SSLUtilHandle, 'ASN1_UTCTIME_free');
  _Asn1IntegerSet := GetProcAddr(SSLUtilHandle, 'ASN1_INTEGER_set');
  _Asn1IntegerGet := GetProcAddr(SSLUtilHandle, 'ASN1_INTEGER_get');
  _i2dX509bio := GetProcAddr(SSLUtilHandle, 'i2d_X509_bio');
  _d2iX509bio := GetProcAddr(SSLUtilHandle, 'd2i_X509_bio');
  _i2dPrivateKeyBio := GetProcAddr(SSLUtilHandle, 'i2d_PrivateKey_bio');
  _OPENSSL_sk_new_null:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_new_null');
  _OPENSSL_sk_num:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_num');
  _OPENSSL_sk_value:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_value');
  _OPENSSL_sk_pop_free:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_pop_free');
  _OPENSSL_sk_free:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_free');
  _OPENSSL_sk_insert:= GetProcAddr(SSLUtilHandle, 'OPENSSL_sk_insert');
  _SSL_CTX_get_cert_store:= GetProcAddr(SSLLibHandle, 'SSL_CTX_get_cert_store');
  _X509_STORE_add_cert := GetProcAddr(SSLUtilHandle, 'X509_STORE_add_cert');

  _EVP_enc_null := GetProcAddr(SSLUtilHandle, 'EVP_enc_null');
  _EVP_rc2_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_cbc');
  _EVP_rc2_40_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_40_cbc');
  _EVP_rc2_64_cbc := GetProcAddr(SSLUtilHandle, 'EVP_rc2_64_cbc');
  _EVP_rc4 := GetProcAddr(SSLUtilHandle, 'EVP_rc4');
  _EVP_rc4_40 := GetProcAddr(SSLUtilHandle, 'EVP_rc4_40');
  _EVP_des_cbc := GetProcAddr(SSLUtilHandle, 'EVP_des_cbc');
  _EVP_des_ede3_cbc := GetProcAddr(SSLUtilHandle, 'EVP_des_ede3_cbc');
  _EVP_aes_128_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_128_cbc');
  _EVP_aes_192_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_192_cbc');
  _EVP_aes_256_cbc := GetProcAddr(SSLUtilHandle, 'EVP_aes_256_cbc');
  _EVP_aes_128_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_128_cfb8');
  _EVP_aes_192_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_192_cfb8');
  _EVP_aes_256_cfb8 := GetProcAddr(SSLUtilHandle, 'EVP_aes_256_cfb8');
  _EVP_camellia_128_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_128_cbc');
  _EVP_camellia_192_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_192_cbc');
  _EVP_camellia_256_cbc := GetProcAddr(SSLUtilHandle, 'EVP_camellia_256_cbc');
  _EVP_sha256 := GetProcAddr(SSLUtilHandle, 'EVP_sha256');

  _EVP_MD_CTX_new := GetProcAddr(SSLUtilHandle, 'EVP_MD_CTX_new');
  _EVP_MD_CTX_free := GetProcAddr(SSLUtilHandle, 'EVP_MD_CTX_free');

  _EVP_PKEY_CTX_new := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_CTX_new');
  _EVP_PKEY_CTX_free := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_CTX_free');
  _EVP_PKEY_CTX_ctrl := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_CTX_ctrl');
  _EVP_PKEY_encrypt_init := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_encrypt_init');
  _EVP_PKEY_encrypt := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_encrypt');
  _EVP_PKEY_decrypt_init := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_decrypt_init');
  _EVP_PKEY_decrypt := GetProcAddr(SSLUtilHandle, 'EVP_PKEY_decrypt');

  _EVP_DigestSignInit := GetProcAddr(SSLUtilHandle, 'EVP_DigestSignInit');
  _EVP_DigestSignFinal := GetProcAddr(SSLUtilHandle, 'EVP_DigestSignFinal');
  _EVP_DigestVerifyInit := GetProcAddr(SSLUtilHandle, 'EVP_DigestVerifyInit');
  _EVP_DigestVerifyFinal := GetProcAddr(SSLUtilHandle, 'EVP_DigestVerifyFinal');
   // 3DES functions
  _DESsetoddparity := GetProcAddr(SSLUtilHandle, 'des_set_odd_parity');
  _DESsetkeychecked := GetProcAddr(SSLUtilHandle, 'des_set_key_checked');
  _DESsetkey := GetProcAddr(SSLUtilHandle, 'des_set_key');
  _DESecbencrypt := GetProcAddr(SSLUtilHandle, 'des_ecb_encrypt');
  //
  _CRYPTOnumlocks := GetProcAddr(SSLUtilHandle, 'CRYPTO_num_locks');
  _CRYPTOsetlockingcallback := GetProcAddr(SSLUtilHandle, 'CRYPTO_set_locking_callback');
   // RAND functions
  _RAND_set_rand_method := GetProcAddr(SSLUtilHandle, 'RAND_set_rand_method');
  _RAND_get_rand_method := GetProcAddr(SSLUtilHandle, 'RAND_get_rand_method');
  _RAND_SSLeay := GetProcAddr(SSLUtilHandle, 'RAND_SSLeay');
  _RAND_cleanup := GetProcAddr(SSLUtilHandle, 'RAND_cleanup');
  _RAND_bytes := GetProcAddr(SSLUtilHandle, 'RAND_bytes');
  _RAND_pseudo_bytes := GetProcAddr(SSLUtilHandle, 'RAND_pseudo_bytes');
  _RAND_seed := GetProcAddr(SSLUtilHandle, 'RAND_seed');
  _RAND_add := GetProcAddr(SSLUtilHandle, 'RAND_add');
  _RAND_load_file := GetProcAddr(SSLUtilHandle, 'RAND_load_file');
  _RAND_write_file := GetProcAddr(SSLUtilHandle, 'RAND_write_file');
  _RAND_file_name := GetProcAddr(SSLUtilHandle, 'RAND_file_name');
  _RAND_status := GetProcAddr(SSLUtilHandle, 'RAND_status');
  _RAND_query_egd_bytes := GetProcAddr(SSLUtilHandle, 'RAND_query_egd_bytes'); // 0.9.7+
  _RAND_egd := GetProcAddr(SSLUtilHandle, 'RAND_egd');
  _RAND_egd_bytes := GetProcAddr(SSLUtilHandle, 'RAND_egd_bytes');
  _ERR_load_RAND_strings := GetProcAddr(SSLUtilHandle, 'ERR_load_RAND_strings');
  _RAND_poll := GetProcAddr(SSLUtilHandle, 'RAND_poll');
   // RSA Functions
  _RSA_new := GetProcAddr(SSLUtilHandle, 'RSA_new');
  _RSA_new_method := GetProcAddr(SSLUtilHandle, 'RSA_new_method');
  _RSA_size := GetProcAddr(SSLUtilHandle, 'RSA_size');
  _RsaGenerateKey := GetProcAddr(SSLUtilHandle, 'RSA_generate_key');
  _RSA_generate_key_ex := GetProcAddr(SSLUtilHandle, 'RSA_generate_key_ex');
  _RSA_check_key := GetProcAddr(SSLUtilHandle, 'RSA_check_key');
  _RSA_public_encrypt := GetProcAddr(SSLUtilHandle, 'RSA_public_encrypt');
  _RSA_private_encrypt := GetProcAddr(SSLUtilHandle, 'RSA_private_encrypt');
  _RSA_public_decrypt := GetProcAddr(SSLUtilHandle, 'RSA_public_decrypt');
  _RSA_private_decrypt := GetProcAddr(SSLUtilHandle, 'RSA_private_decrypt');
  _RSA_free := GetProcAddr(SSLUtilHandle, 'RSA_free');
  _RSA_flags := GetProcAddr(SSLUtilHandle, 'RSA_flags');
  _RSA_set_default_method := GetProcAddr(SSLUtilHandle, 'RSA_set_default_method');
  _RSA_get_default_method := GetProcAddr(SSLUtilHandle, 'RSA_get_default_method');
  _RSA_get_method := GetProcAddr(SSLUtilHandle, 'RSA_get_method');
  _RSA_set_method := GetProcAddr(SSLUtilHandle, 'RSA_set_method');
  _RSA_get0_n := GetProcAddr(SSLUtilHandle, 'RSA_get0_n');
  _RSA_get0_e := GetProcAddr(SSLUtilHandle, 'RSA_get0_e');
  _RSA_get0_d := GetProcAddr(SSLUtilHandle, 'RSA_get0_d');
  _RSA_get0_p := GetProcAddr(SSLUtilHandle, 'RSA_get0_p');
  _RSA_get0_q := GetProcAddr(SSLUtilHandle, 'RSA_get0_q');
  _RSA_set0_key := GetProcAddr(SSLUtilHandle, 'RSA_set0_key');
  _RSA_get_version := GetProcAddr(SSLUtilHandle, 'RSA_get_version');
  _RSA_pkey_ctx_ctrl := GetProcAddr(SSLUtilHandle, 'RSA_pkey_ctx_ctrl');

   // X509 Functions
  _d2i_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'd2i_RSAPublicKey');
  _i2d_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'i2d_RSAPublicKey');
  _d2i_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'd2i_RSAPrivateKey');
  _i2d_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'i2d_RSAPrivateKey');
  _d2i_PubKey := GetProcAddr(SSLUtilHandle, 'd2i_PUBKEY');
  _d2i_AutoPrivateKey := GetProcAddr(SSLUtilHandle, 'd2i_AutoPrivateKey');
   // ERR Functions
  _ERR_error_string := GetProcAddr(SSLUtilHandle, 'ERR_error_string');
   // EVP Functions
   _OpenSSL_add_all_algorithms := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_algorithms');
  _OpenSSL_add_all_ciphers := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_ciphers');
  _OpenSSL_add_all_digests := GetProcAddr(SSLUtilHandle, 'OpenSSL_add_all_digests');
  _EVP_DigestInit := GetProcAddr(SSLUtilHandle, 'EVP_DigestInit');
  _EVP_DigestUpdate := GetProcAddr(SSLUtilHandle, 'EVP_DigestUpdate');
  _EVP_DigestFinal := GetProcAddr(SSLUtilHandle, 'EVP_DigestFinal');
  _EVP_SignFinal := GetProcAddr(SSLUtilHandle, 'EVP_SignFinal');
  _EVP_PKEY_size := GetProcAddr(SSLUtilHandle,'EVP_PKEY_size');
  _EVP_PKEY_free := GetProcAddr(SSLUtilHandle,'EVP_PKEY_free');
  _EVP_PKEY_new_mac_key := GetProcAddr(SSLUtilHandle,'EVP_PKEY_new_mac_key'); // Tz HMAC
  _EVP_VerifyFinal := GetProcAddr(SSLUtilHandle,'EVP_VerifyFinal');
  _EVP_get_cipherbyname := GetProcAddr(SSLUtilHandle, 'EVP_get_cipherbyname');
  _EVP_get_digestbyname := GetProcAddr(SSLUtilHandle, 'EVP_get_digestbyname');
  _EVP_CIPHER_CTX_init := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_init');
  _EVP_CIPHER_CTX_cleanup := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_cleanup');
  _EVP_CIPHER_CTX_new := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_new'); // Tz Cipher
  _EVP_CIPHER_CTX_free := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_free'); // Tz Cipher
  _EVP_CIPHER_CTX_set_key_length := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_set_key_length');
  _EVP_CIPHER_CTX_ctrl := GetProcAddr(SSLUtilHandle, 'EVP_CIPHER_CTX_ctrl');
  _EVP_EncryptInit := GetProcAddr(SSLUtilHandle, 'EVP_EncryptInit');
  _EVP_EncryptUpdate := GetProcAddr(SSLUtilHandle, 'EVP_EncryptUpdate');
  _EVP_EncryptFinal := GetProcAddr(SSLUtilHandle, 'EVP_EncryptFinal');
  _EVP_DecryptInit := GetProcAddr(SSLUtilHandle, 'EVP_DecryptInit');
  _EVP_DecryptUpdate := GetProcAddr(SSLUtilHandle, 'EVP_DecryptUpdate');
  _EVP_DecryptFinal := GetProcAddr(SSLUtilHandle, 'EVP_DecryptFinal');
   // PEM
  _PEM_read_bio_PrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_PrivateKey');
  _PEM_read_bio_PUBKEY := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_PUBKEY');
  _PEM_write_bio_PrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_PrivateKey');
  _PEM_write_bio_PUBKEY := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_PUBKEY');
  _PEM_read_bio_X509 := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_X509');
  _PEM_write_bio_X509 := GetProcAddr(SSLUtilHandle,'PEM_write_bio_X509');
  _PEM_write_bio_X509_REQ := GetProcAddr(SSLUtilHandle,'PEM_write_bio_X509_REQ');
  _PEM_write_bio_PKCS7 := GetProcAddr(SSLUtilHandle,'PEM_write_bio_PKCS7');
  _PEM_read_bio_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_RSAPrivateKey');
  _PEM_write_bio_RSAPrivateKey := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_RSAPrivateKey');
  _PEM_read_bio_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'PEM_read_bio_RSAPublicKey');
  _PEM_write_bio_RSAPublicKey := GetProcAddr(SSLUtilHandle, 'PEM_write_bio_RSAPublicKey');
  // BIO
  _BIO_ctrl := GetProcAddr(SSLUtilHandle, 'BIO_ctrl');
  _BIO_s_file := GetProcAddr(SSLUtilHandle, 'BIO_s_file');
  _BIO_new_file := GetProcAddr(SSLUtilHandle, 'BIO_new_file');
  _BIO_new_mem_buf := GetProcAddr(SSLUtilHandle, 'BIO_new_mem_buf');
  // PKCS7
  _PKCS7_ISSUER_AND_SERIAL_new:=GetProcAddr(SSLUtilHandle,'PKCS7_ISSUER_AND_SERIAL_new');
  _PKCS7_ISSUER_AND_SERIAL_free:=GetProcAddr(SSLUtilHandle,'PKCS7_ISSUER_AND_SERIAL_free');
  _PKCS7_ISSUER_AND_SERIAL_digest:=GetProcAddr(SSLUtilHandle,'PKCS7_ISSUER_AND_SERIAL_digest');
  _PKCS7_dup:=GetProcAddr(SSLUtilHandle,'PKCS7_dup');
  _PEM_write_bio_PKCS7_stream:=GetProcAddr(SSLUtilHandle,'PEM_write_bio_PKCS7_stream');
  _PKCS7_SIGNER_INFO_new:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNER_INFO_new');
  _PKCS7_SIGNER_INFO_free:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNER_INFO_free');
  _PKCS7_RECIP_INFO_new:=GetProcAddr(SSLUtilHandle,'PKCS7_RECIP_INFO_new');
  _PKCS7_RECIP_INFO_free:=GetProcAddr(SSLUtilHandle,'PKCS7_RECIP_INFO_free');
  _PKCS7_SIGNED_new:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNED_new');
  _PKCS7_SIGNED_free:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNED_free');
  _PKCS7_ENC_CONTENT_new:=GetProcAddr(SSLUtilHandle,'PKCS7_ENC_CONTENT_new');
  _PKCS7_ENC_CONTENT_free:=GetProcAddr(SSLUtilHandle,'PKCS7_ENC_CONTENT_free');
  _PKCS7_ENVELOPE_new:=GetProcAddr(SSLUtilHandle,'PKCS7_ENVELOPE_new');
  _PKCS7_ENVELOPE_free:=GetProcAddr(SSLUtilHandle,'PKCS7_ENVELOPE_free');
  _PKCS7_SIGN_ENVELOPE_new:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGN_ENVELOPE_new');
  _PKCS7_SIGN_ENVELOPE_free:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGN_ENVELOPE_free');
  _PKCS7_DIGEST_new:=GetProcAddr(SSLUtilHandle,'PKCS7_DIGEST_new');
  _PKCS7_DIGEST_free:=GetProcAddr(SSLUtilHandle,'PKCS7_DIGEST_free');
  _PKCS7_ENCRYPT_new:=GetProcAddr(SSLUtilHandle,'PKCS7_ENCRYPT_new');
  _PKCS7_ENCRYPT_free:=GetProcAddr(SSLUtilHandle,'PKCS7_ENCRYPT_free');
  _PKCS7_new:=GetProcAddr(SSLUtilHandle,'PKCS7_new');
  _PKCS7_free:=GetProcAddr(SSLUtilHandle,'PKCS7_free');
  _PKCS7_print_ctx:=GetProcAddr(SSLUtilHandle,'PKCS7_print_ctx');
  _PKCS7_ctrl:=GetProcAddr(SSLUtilHandle,'PKCS7_ctrl');
  _PKCS7_set_type:=GetProcAddr(SSLUtilHandle,'PKCS7_set_type');
  _PKCS7_set0_type_other:=GetProcAddr(SSLUtilHandle,'PKCS7_set0_type_other');
  _PKCS7_set_content:=GetProcAddr(SSLUtilHandle,'PKCS7_set_content');
  _PKCS7_SIGNER_INFO_set:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNER_INFO_set');
  _PKCS7_SIGNER_INFO_sign:=GetProcAddr(SSLUtilHandle,'PKCS7_SIGNER_INFO_sign');
  _PKCS7_add_signer:=GetProcAddr(SSLUtilHandle,'PKCS7_add_signer');
  _PKCS7_add_certificate:=GetProcAddr(SSLUtilHandle,'PKCS7_add_certificate');
  _PKCS7_add_crl:=GetProcAddr(SSLUtilHandle,'PKCS7_add_crl');
  _PKCS7_content_new:=GetProcAddr(SSLUtilHandle,'PKCS7_content_new');
  _PKCS7_add_signature:=GetProcAddr(SSLUtilHandle,'PKCS7_add_signature');
  _PKCS7_cert_from_signer_info:=GetProcAddr(SSLUtilHandle,'PKCS7_cert_from_signer_info');
  _PKCS7_set_digest:=GetProcAddr(SSLUtilHandle,'PKCS7_set_digest');
  _PKCS7_add_recipient:=GetProcAddr(SSLUtilHandle,'PKCS7_add_recipient');
  _PKCS7_add_recipient_info:=GetProcAddr(SSLUtilHandle,'PKCS7_add_recipient_info');
  _PKCS7_RECIP_INFO_set:=GetProcAddr(SSLUtilHandle,'PKCS7_RECIP_INFO_set');
  _PKCS7_set_cipher:=GetProcAddr(SSLUtilHandle,'PKCS7_set_cipher');
  _PKCS7_get_issuer_and_serial:=GetProcAddr(SSLUtilHandle,'PKCS7_get_issuer_and_serial');
  _PKCS7_digest_from_attributes:=GetProcAddr(SSLUtilHandle,'PKCS7_digest_from_attributes');
  _PKCS7_add_signed_attribute:=GetProcAddr(SSLUtilHandle,'PKCS7_add_signed_attribute');
  _PKCS7_add_attribute:=GetProcAddr(SSLUtilHandle,'PKCS7_add_attribute');
  _PKCS7_get_attribute:=GetProcAddr(SSLUtilHandle,'PKCS7_get_attribute');
  _PKCS7_get_signed_attribute:=GetProcAddr(SSLUtilHandle,'PKCS7_get_signed_attribute');
  _PKCS7_set_signed_attributes:=GetProcAddr(SSLUtilHandle,'PKCS7_set_signed_attributes');
  _PKCS7_set_attributes:=GetProcAddr(SSLUtilHandle,'PKCS7_set_attributes');
  _PKCS7_sign:=GetProcAddr(SSLUtilHandle,'PKCS7_sign');
  _PKCS7_sign_add_signer:=GetProcAddr(SSLUtilHandle,'PKCS7_sign_add_signer');
  _PKCS7_final:=GetProcAddr(SSLUtilHandle,'PKCS7_final');
  _PKCS7_verify:=GetProcAddr(SSLUtilHandle,'PKCS7_verify');
  _PKCS7_encrypt:=GetProcAddr(SSLUtilHandle,'PKCS7_encrypt');
  _PKCS7_decrypt:=GetProcAddr(SSLUtilHandle,'PKCS7_decrypt');
  _PKCS7_add_attrib_smimecap:=GetProcAddr(SSLUtilHandle,'PKCS7_add_attrib_smimecap');
  _PKCS7_simple_smimecap:=GetProcAddr(SSLUtilHandle,'PKCS7_simple_smimecap');
  _PKCS7_add_attrib_content_type:=GetProcAddr(SSLUtilHandle,'PKCS7_add_attrib_content_type');
  _PKCS7_add0_attrib_signing_time:=GetProcAddr(SSLUtilHandle,'PKCS7_add0_attrib_signing_time');
  _PKCS7_add1_attrib_digest:=GetProcAddr(SSLUtilHandle,'PKCS7_add1_attrib_digest');
  _BIO_new_PKCS7:=GetProcAddr(SSLUtilHandle,'BIO_new_PKCS7');
  _ERR_load_PKCS7_strings:=GetProcAddr(SSLUtilHandle,'ERR_load_PKCS7_strings');

  // BN
  _BN_new:=GetProcAddr(SSLUtilHandle,'BN_new');
  _BN_secure_new:=GetProcAddr(SSLUtilHandle,'BN_secure_new');
  _BN_clear_free:=GetProcAddr(SSLUtilHandle,'BN_clear_free');
  _BN_copy:=GetProcAddr(SSLUtilHandle,'BN_copy');
  _BN_swap:=GetProcAddr(SSLUtilHandle,'BN_swap');
  _BN_print:=GetProcAddr(SSLUtilHandle, 'BN_print');
  _BN_bin2bn:=GetProcAddr(SSLUtilHandle,'BN_bin2bn');
  _BN_bn2bin:=GetProcAddr(SSLUtilHandle,'BN_bn2bin');
  _BN_hex2bn:=GetProcAddr(SSLUtilHandle, 'BN_hex2bn');
  _BN_dec2bn:=GetProcAddr(SSLUtilHandle, 'BN_dec2bn');
  _BN_bn2hex:=GetProcAddr(SSLUtilHandle, 'BN_bn2hex');
  _BN_bn2dec:=GetProcAddr(SSLUtilHandle, 'BN_bn2dec');
  _BN_bn2binpad:=GetProcAddr(SSLUtilHandle,'BN_bn2binpad');
  _BN_lebin2bn:=GetProcAddr(SSLUtilHandle,'BN_lebin2bn');
  _BN_bn2lebinpad:=GetProcAddr(SSLUtilHandle,'BN_bn2lebinpad');
  _BN_mpi2bn:=GetProcAddr(SSLUtilHandle,'BN_mpi2bn');
  _BN_bn2mpi:=GetProcAddr(SSLUtilHandle,'BN_bn2mpi');
  _BN_sub:=GetProcAddr(SSLUtilHandle,'BN_sub');
  _BN_usub:=GetProcAddr(SSLUtilHandle,'BN_usub');
  _BN_uadd:=GetProcAddr(SSLUtilHandle,'BN_uadd');
  _BN_add:=GetProcAddr(SSLUtilHandle,'BN_add');
  _BN_mul:=GetProcAddr(SSLUtilHandle,'BN_mul');
  _BN_sqr:=GetProcAddr(SSLUtilHandle,'BN_sqr');
  _BN_set_negative:=GetProcAddr(SSLUtilHandle,'BN_set_negative');
  _BN_is_negative:=GetProcAddr(SSLUtilHandle,'BN_is_negative');
  _BN_div:=GetProcAddr(SSLUtilHandle,'BN_div');
  _BN_mod:=GetProcAddr(SSLUtilHandle,'BN_mod');
  _BN_nnmod:=GetProcAddr(SSLUtilHandle,'BN_nnmod');
  _BN_mod_add:=GetProcAddr(SSLUtilHandle,'BN_mod_add');
  _BN_mod_add_quick:=GetProcAddr(SSLUtilHandle,'BN_mod_add_quick');
  _BN_mod_sub:=GetProcAddr(SSLUtilHandle,'BN_mod_sub');
  _BN_mod_sub_quick:=GetProcAddr(SSLUtilHandle,'BN_mod_sub_quick');
  _BN_mod_mul:=GetProcAddr(SSLUtilHandle,'BN_mod_mul');
  _BN_mod_sqr:=GetProcAddr(SSLUtilHandle,'BN_mod_sqr');
  _BN_mod_lshift1:=GetProcAddr(SSLUtilHandle,'BN_mod_lshift1');
  _BN_mod_lshift1_quick:=GetProcAddr(SSLUtilHandle,'BN_mod_lshift1_quick');
  _BN_mod_lshift:=GetProcAddr(SSLUtilHandle,'BN_mod_lshift');
  _BN_mod_lshift_quick:=GetProcAddr(SSLUtilHandle,'BN_mod_lshift_quick');
  _BN_mod_word:=GetProcAddr(SSLUtilHandle,'BN_mod_word');
  _BN_div_word:=GetProcAddr(SSLUtilHandle,'BN_div_word');
  _BN_mul_word:=GetProcAddr(SSLUtilHandle,'BN_mul_word');
  _BN_add_word:=GetProcAddr(SSLUtilHandle,'BN_add_word');
  _BN_sub_word:=GetProcAddr(SSLUtilHandle,'BN_sub_word');
  _BN_set_word:=GetProcAddr(SSLUtilHandle,'BN_set_word');
  _BN_get_word:=GetProcAddr(SSLUtilHandle,'BN_get_word');
  _BN_cmp:=GetProcAddr(SSLUtilHandle,'BN_cmp');
  _BN_free:=GetProcAddr(SSLUtilHandle,'BN_free');
  _OSSL_LIB_CTX_get0_global_default:=GetProcAddr(SSLUtilHandle,'OSSL_LIB_CTX_get0_global_default');
  _OSSL_PROVIDER_available:=GetProcAddr(SSLUtilHandle,'OSSL_PROVIDER_available');
  _OSSL_PROVIDER_load:=GetProcAddr(SSLUtilHandle,'OSSL_PROVIDER_load');
  _OSSL_PROVIDER_unload:=GetProcAddr(SSLUtilHandle,'OSSL_PROVIDER_unload');
  _OSSL_PROVIDER_set_default_search_path:=GetProcAddr(SSLUtilHandle,'OSSL_PROVIDER_set_default_search_path');
end;

Function LoadUtilLibrary : Boolean;

var
  i: Integer;
begin
  Result:=(SSLUtilHandle<>0);
  if not Result then
  begin
    for i := low(DLLUtilNames) to high(DLLUtilNames) do
    begin
      SSLUtilHandle := LoadLib(DLLUtilNames[i]);
      if SSLUtilHandle <> 0 then
        break;
    end;

    Result:=(SSLUtilHandle<>0);
  end;
end;



Procedure ClearSSLEntryPoints;

begin
  _OpenSSLVersionNum := Nil;
  _OpenSSLVersion := Nil;
  _SslGetError := nil;
  _SslLibraryInit := nil;
  _SslLoadErrorStrings := nil;
  _SslCtxSetCipherList := nil;
  _SslCtxNew := nil;
  _SslCtxFree := nil;
  _SslSetFd := nil;
  _SslCtrl := nil;
  _SslCTXCtrl := nil;
  _SslCtxSetMinProtoVersion := nil;
  _SslCtxSetMaxProtoVersion := nil;
  _SslMethodV2 := nil;
  _SslMethodV3 := nil;
  _SslMethodTLSV1 := nil;
  _SslMethodTLSV1_1 := nil;
  _SslMethodTLSV1_2 := nil;
  _SslMethodV23 := nil;
  _SslTLSMethod := nil;
  _SslCtxUsePrivateKey := nil;
  _SslCtxUsePrivateKeyASN1 := nil;
  _SslCtxUsePrivateKeyFile := nil;
  _SslCtxUseCertificate := nil;
  _SslCtxUseCertificateASN1 := nil;
  _SslCtxUseCertificateFile := nil;
  _SslCtxUseCertificateChainFile := nil;
  _SslCtxCheckPrivateKeyFile := nil;
  _SslCtxSetDefaultPasswdCb := nil;
  _SslCtxSetDefaultPasswdCbUserdata := nil;
  _SslCtxLoadVerifyLocations := nil;
  _SslNew := nil;
  _SslFree := nil;
  _SslAccept := nil;
  _SslConnect := nil;
  _SslShutdown := nil;
  _SslRead := nil;
  _SslPeek := nil;
  _SslWrite := nil;
  _SslPending := nil;
  _SslGetPeerCertificate := nil;
  _SslGetVersion := nil;
  _SslCtxSetVerify := nil;
  _SslGetCurrentCipher := nil;
  _SslCipherGetName := nil;
  _SslCipherGetBits := nil;
  _SslGetVerifyResult := nil;
  _SslGetServername := nil;
  _SslCtxCallbackCtrl := nil;
  _SslSetSslCtx := nil;
  _PKCS7_ISSUER_AND_SERIAL_new:=nil;
  _PKCS7_ISSUER_AND_SERIAL_free:=nil;
  _PKCS7_ISSUER_AND_SERIAL_digest:=nil;
  _PKCS7_dup:=nil;
  _PEM_write_bio_PKCS7_stream:=nil;
  _PKCS7_SIGNER_INFO_new:=nil;
  _PKCS7_SIGNER_INFO_free:=nil;
  _PKCS7_RECIP_INFO_new:=nil;
  _PKCS7_RECIP_INFO_free:=nil;
  _PKCS7_SIGNED_new:=nil;
  _PKCS7_SIGNED_free:=nil;
  _PKCS7_ENC_CONTENT_new:=nil;
  _PKCS7_ENC_CONTENT_free:=nil;
  _PKCS7_ENVELOPE_new:=nil;
  _PKCS7_ENVELOPE_free:=nil;
  _PKCS7_SIGN_ENVELOPE_new:=nil;
  _PKCS7_SIGN_ENVELOPE_free:=nil;
  _PKCS7_DIGEST_new:=nil;
  _PKCS7_DIGEST_free:=nil;
  _PKCS7_ENCRYPT_new:=nil;
  _PKCS7_ENCRYPT_free:=nil;
  _PKCS7_new:=nil;
  _PKCS7_free:=nil;
  _PKCS7_print_ctx:=nil;
  _PKCS7_ctrl:=nil;
  _PKCS7_set_type:=nil;
  _PKCS7_set0_type_other:=nil;
  _PKCS7_set_content:=nil;
  _PKCS7_SIGNER_INFO_set:=nil;
  _PKCS7_SIGNER_INFO_sign:=nil;
  _PKCS7_add_signer:=nil;
  _PKCS7_add_certificate:=nil;
  _PKCS7_add_crl:=nil;
  _PKCS7_content_new:=nil;
  _PKCS7_add_signature:=nil;
  _PKCS7_cert_from_signer_info:=nil;
  _PKCS7_set_digest:=nil;
  _PKCS7_add_recipient:=nil;
  _PKCS7_add_recipient_info:=nil;
  _PKCS7_RECIP_INFO_set:=nil;
  _PKCS7_set_cipher:=nil;
  _PKCS7_get_issuer_and_serial:=nil;
  _PKCS7_digest_from_attributes:=nil;
  _PKCS7_add_signed_attribute:=nil;
  _PKCS7_add_attribute:=nil;
  _PKCS7_get_attribute:=nil;
  _PKCS7_get_signed_attribute:=nil;
  _PKCS7_set_signed_attributes:=nil;
  _PKCS7_set_attributes:=nil;
  _PKCS7_sign:=nil;
  _PKCS7_sign_add_signer:=nil;
  _PKCS7_final:=nil;
  _PKCS7_verify:=nil;
  _PKCS7_encrypt:=nil;
  _PKCS7_decrypt:=nil;
  _PKCS7_add_attrib_smimecap:=nil;
  _PKCS7_simple_smimecap:=nil;
  _PKCS7_add_attrib_content_type:=nil;
  _PKCS7_add0_attrib_signing_time:=nil;
  _PKCS7_add1_attrib_digest:=nil;
  _BIO_new_PKCS7:=nil;
  _ERR_load_PKCS7_strings:=nil;

  // BN
  _BN_new:=nil;
  _BN_secure_new:=nil;
  _BN_clear_free:=nil;
  _BN_copy:=nil;
  _BN_swap:=nil;
  _BN_print:=nil;
  _BN_bin2bn:=nil;
  _BN_bn2bin:=nil;
  _BN_hex2bn:=nil;
  _BN_dec2bn:=nil;
  _BN_bn2hex:=nil;
  _BN_bn2dec:=nil;
  _BN_bn2binpad:=nil;
  _BN_lebin2bn:=nil;
  _BN_bn2lebinpad:=nil;
  _BN_mpi2bn:=nil;
  _BN_bn2mpi:=nil;
  _BN_sub:=nil;
  _BN_usub:=nil;
  _BN_uadd:=nil;
  _BN_add:=nil;
  _BN_mul:=nil;
  _BN_sqr:=nil;
  _BN_set_negative:=nil;
  _BN_is_negative:=nil;
  _BN_div:=nil;
  _BN_mod:=nil;
  _BN_nnmod:=nil;
  _BN_mod_add:=nil;
  _BN_mod_add_quick:=nil;
  _BN_mod_sub:=nil;
  _BN_mod_sub_quick:=nil;
  _BN_mod_mul:=nil;
  _BN_mod_sqr:=nil;
  _BN_mod_lshift1:=nil;
  _BN_mod_lshift1_quick:=nil;
  _BN_mod_lshift:=nil;
  _BN_mod_lshift_quick:=nil;
  _BN_mod_word:=nil;
  _BN_div_word:=nil;
  _BN_mul_word:=nil;
  _BN_add_word:=nil;
  _BN_sub_word:=nil;
  _BN_set_word:=nil;
  _BN_get_word:=nil;
  _BN_cmp:=nil;
  _BN_free:=nil;
  _OSSL_LIB_CTX_get0_global_default:=nil;
  _OSSL_PROVIDER_available:=nil;
  _OSSL_PROVIDER_load:=nil;
  _OSSL_PROVIDER_unload:=nil;
  _OSSL_PROVIDER_set_default_search_path:=nil;
end;

Procedure UnloadSSLLib;

begin
  if (SSLLibHandle<>0) then
    begin
    FreeLibrary(SSLLibHandle);
    SSLLibHandle:=0;
    end;
end;

Procedure UnloadUtilLib;

begin
  if (SSLUtilHandle<>0) then
     begin
     FreeLibrary(SSLUtilHandle);
     SSLUtilHandle := 0;
     end;
end;

Procedure ClearUtilEntryPoints;

begin
  _ERR_load_crypto_strings := nil;
  _X509New := nil;
  _X509_REQ_new := nil;
  _X509_REQ_free := nil;
  _X509_REQ_set_subject_name := nil;
  _X509_REQ_set_pubkey := nil;
  _X509_REQ_sign := nil;
  _X509Free := nil;
  _X509_NAME_new := nil;
  _X509_NAME_free := nil;
  _X509NameOneline := nil;
  _X509NAMEprintEx := nil;
  _X509GetSubjectName := nil;
  _X509GetIssuerName := nil;
  _X509NameHash := nil;
  _X509Digest := nil;
  _X509print := nil;
  _X509SetVersion := nil;
  _X509SetPubkey := nil;
  _X509GetPubkey := nil;
  _X509SetIssuerName := nil;
  _X509NameAddEntryByTxt := nil;
  _X509Sign := nil;
  _X509GmtimeAdj := nil;
  _X509GetNotAfter := nil;
  _X509GetNotBefore := nil;
  _X509SetNotBefore := nil;
  _X509SetNotAfter := nil;
  _X509GetSerialNumber := nil;
  _X509GetExt := nil;
  _X509ExtensionGetData := nil;
  _EvpPkeyNew := nil;
  _EvpPkeyFree := nil;
  _EvpPkeyAssign := nil;
  _EvpPkeyGet1RSA := nil;
  _EvpPkeySet1RSA := nil;
  _EVPCleanup := nil;
  _EvpGetDigestByName := nil;
  _ErrErrorString := nil;
  _ErrGetError := nil;
  _ErrClearError := nil;
  _ErrFreeStrings := nil;
  _ErrRemoveState := nil;
  _RandScreen := nil;
  _BioNew := nil;
  _BioFreeAll := nil;
  _BioSMem := nil;
  _BioCtrlPending := nil;
  _BioRead := nil;
  _BioWrite := nil;
  _BioReset := nil;
  _d2iPKCS12bio := nil;
  _PKCS12parse := nil;
  _PKCS12free := nil;
  _Asn1UtctimeSetString := nil;
  _Asn1StringTypeNew := nil;
  _Asn1UtctimePrint := nil;
  _Asn1UtctimeFree := nil;
  _Asn1IntegerSet:= nil;
  _Asn1IntegerGet:= nil;
  _i2dX509bio := nil;
  _d2iX509bio := nil;
  _i2dPrivateKeyBio := nil;
  _OPENSSL_sk_new_null := nil;
  _OPENSSL_sk_num := nil;
  _OPENSSL_sk_value := nil;
  _OPENSSL_sk_pop_free := nil;
  _OPENSSL_sk_free := nil;
  _OPENSSL_sk_insert := nil;
  _SSL_CTX_get_cert_store := nil;
  _X509_STORE_add_cert := nil;
  // 3DES functions
  _DESsetoddparity := nil;
  _DESsetkeychecked := nil;
  _DESecbencrypt := nil;
  //
  _CRYPTOnumlocks := nil;
  _CRYPTOsetlockingcallback := nil;
  // RAND functions
  _RAND_set_rand_method := nil;
  _RAND_get_rand_method := nil;
  _RAND_SSLeay := nil;
  _RAND_cleanup := nil;
  _RAND_bytes := nil;
  _RAND_pseudo_bytes := nil;
  _RAND_seed := nil;
  _RAND_add := nil;
  _RAND_load_file := nil;
  _RAND_write_file := nil;
  _RAND_file_name := nil;
  _RAND_status := nil;
  _RAND_query_egd_bytes := nil;
  _RAND_egd := nil;
  _RAND_egd_bytes := nil;
  _ERR_load_RAND_strings := nil;
  _RAND_poll := nil;
  // RSA Functions
  _RSA_new := nil;
  _RSA_new_method := nil;
  _RSA_size := nil;
  _RsaGenerateKey := nil;
  _RSA_generate_key_ex := nil;
  _RSA_check_key := nil;
  _RSA_public_encrypt := nil;
  _RSA_private_encrypt := nil;
  _RSA_public_decrypt := nil;
  _RSA_private_decrypt := nil;
  _RSA_free := nil;
  _RSA_flags := nil;
  _RSA_set_default_method := nil;
  _RSA_get_default_method := nil;
  _RSA_get_method := nil;
  _RSA_set_method := nil;
  _RSA_get0_n := nil;
  _RSA_get0_e := nil;
  _RSA_get0_d := nil;
  _RSA_get0_p := nil;
  _RSA_get0_q := nil;
  _RSA_set0_key := nil;
  _RSA_get_version := nil;
  _RSA_pkey_ctx_ctrl := nil;
  // X509 Functions
  _d2i_RSAPublicKey := nil;
  _i2d_RSAPublicKey := nil;
  _d2i_RSAPrivateKey := nil;
  _i2d_RSAPrivateKey := nil;
  _d2i_PubKey := nil;
  _d2i_AutoPrivateKey := nil;
  // ERR Functions
  _ERR_error_string := nil;

  // EVP Functions

  _OpenSSL_add_all_algorithms := nil;
  _OpenSSL_add_all_ciphers := nil;
  _OpenSSL_add_all_digests := nil;
  //
  _EVP_DigestInit := nil;
  _EVP_DigestUpdate := nil;
  _EVP_DigestFinal := nil;

  _EVP_SignFinal := nil;
  _EVP_PKEY_size := nil;
  _EVP_PKEY_free := nil;
  _EVP_PKEY_new_mac_key := nil; // Tz HMAC
  _EVP_VerifyFinal := nil;
  //
  _EVP_get_cipherbyname := nil;
  _EVP_get_digestbyname := nil;
  //
  _EVP_CIPHER_CTX_init := nil;
  _EVP_CIPHER_CTX_cleanup := nil;
  _EVP_CIPHER_CTX_new := nil; // Tz Cipher
  _EVP_CIPHER_CTX_free := nil; // Tz Cipher
  _EVP_CIPHER_CTX_set_key_length := nil;
  _EVP_CIPHER_CTX_ctrl := nil;
  //
  _EVP_EncryptInit := nil;
  _EVP_EncryptUpdate := nil;
  _EVP_EncryptFinal := nil;
  //
  _EVP_DecryptInit := nil;
  _EVP_DecryptUpdate := nil;
  _EVP_DecryptFinal := nil;
  //
  _EVP_sha256 := nil;

  _EVP_MD_CTX_new := nil;
  _EVP_MD_CTX_free := nil;

  _EVP_PKEY_CTX_new := nil;
  _EVP_PKEY_CTX_free := nil;
  _EVP_PKEY_CTX_ctrl := nil;
  _EVP_PKEY_encrypt_init := nil;
  _EVP_PKEY_encrypt := nil;
  _EVP_PKEY_decrypt_init := nil;
  _EVP_PKEY_decrypt := nil;

  _EVP_DigestSignInit := nil;
  _EVP_DigestSignFinal := nil;
  _EVP_DigestVerifyInit := nil;
  _EVP_DigestVerifyFinal := nil;

  // PEM
  _PEM_read_bio_PrivateKey := nil;
  _PEM_read_bio_PUBKEY := nil;
  _PEM_write_bio_PrivateKey := nil;
  _PEM_write_bio_PUBKEY := nil;
  _PEM_read_bio_X509 := nil;
  _PEM_write_bio_X509 := nil;
  _PEM_write_bio_X509_REQ := nil;
  _PEM_write_bio_PKCS7 := nil;
  _PEM_read_bio_RSAPrivateKey := nil ;
  _PEM_write_bio_RSAPrivateKey := nil ;
  _PEM_read_bio_RSAPublicKey := nil ;
  _PEM_write_bio_RSAPublicKey := nil ;

  // BIO
  _BIO_ctrl := nil;
  _BIO_s_file := nil;
  _BIO_new_file := nil;
  _BIO_new_mem_buf := nil;
end;

procedure locking_callback(mode, ltype: integer; lfile: PAnsiChar; line: integer); cdecl;
begin
  if (mode and 1) > 0 then
    TCriticalSection(Locks[ltype]).Enter
  else
    TCriticalSection(Locks[ltype]).Leave;
end;

procedure InitLocks;
var
  n: integer;
  max: integer;
begin
  max:=_CRYPTOnumlocks;
  SetLength(Locks,Max);
  for n := 0 to max-1 do
    Locks[n] := TCriticalSection.Create;

  _CRYPTOsetlockingcallback(@locking_callback);
end;

procedure FreeLocks;
var
  n: integer;
begin
  _CRYPTOsetlockingcallback(nil);
  for n := 0 to Length(Locks)-1 do
    TCriticalSection(Locks[n]).Free;

  SetLength(Locks,0);
end;

Procedure UnloadLibraries;

begin
  SSLloaded := false;
  if SSLLibHandle <> 0 then
  begin
    FreeLibrary(SSLLibHandle);
    SSLLibHandle := 0;
  end;
  if SSLUtilHandle <> 0 then
  begin
    FreeLibrary(SSLUtilHandle);
    SSLUtilHandle := 0;
  end;
end;

Function LoadLibraries : Boolean;
var
  i: Integer;
  {$IfDef MSWINDOWS}
   x: Integer;
   s: String;
  {$EndIf}
begin
  for i := low(DLLUtilNames) to high(DLLUtilNames) do
  begin
    SSLUtilHandle := LoadLib(DLLUtilNames[i]);
    if SSLUtilHandle <> 0 then
      break;
  end;

  {$IfDef MSWINDOWS}
   if (i <= high(DLLSSLNames)) then
     SSLLibHandle := LoadLib(DLLSSLNames[i]);  // Use same DLL pair
  {$Else}
   for i := low(DLLSSLNames) to high(DLLSSLNames) do
   begin
     SSLLibHandle := LoadLib(DLLSSLNames[i]);
     if SSLLibHandle <> 0 then
       break;
   end;
  {$EndIf}

  {$IfDef MSWINDOWS}
  if (SSLUtilHandle <> 0) then
  begin
    SetLength(s, 1024);
    x := GetModuleFilename(SSLUtilHandle, PChar(s), Length(s));
    SetLength(s, x);
    SSLUtilFile := s;
  end;

  if (SSLLibHandle <> 0) then
  begin
    SetLength(s, 1024);
    x := GetModuleFilename(SSLLibHandle, PChar(s), Length(s));
    SetLength(s, x);
    SSLLibFile := s;
  end;
  {$EndIf}

  Result := (SSLLibHandle<>0) and (SSLUtilHandle<>0);
end;

function InitSSLInterface: Boolean;
begin
  Result:=SSLLoaded;
  if Result then
    exit;
  SSLCS.Enter;
  try
    if SSLloaded then
      Exit;

    {$IfDef ANDROID}
    if (SSLLibPath = '') then     // Try to load from "./assets/internal/" first
      SSLLibPath := {$IfNDef FPC}TPath.GetDocumentsPath{$Else}'./assets/internal/'{$EndIf};

    Result := LoadLibraries;
    if (not Result) then         // Try System Default Lib
    begin
      SSLLibPath := '';
      Result := LoadLibraries;
    end;
    {$Else}
    Result := LoadLibraries;
    {$EndIf}

    if Not Result then
    begin
      UnloadLibraries;
      Exit;
    end;

    LoadSSLEntryPoints;
    LoadUtilEntryPoints;

    //init library
    if assigned(_SslLibraryInit) then
      _SslLibraryInit;
    if assigned(_SslLoadErrorStrings) then
      _SslLoadErrorStrings;
    if assigned(_OPENSSLaddallalgorithms) then
      _OPENSSLaddallalgorithms;
    if assigned(_RandScreen) then
      _RandScreen;
    if assigned(_CRYPTOnumlocks) and assigned(_CRYPTOsetlockingcallback) then
      InitLocks;
    SSLloaded := True;

    if IsOpenSSL3 then
    begin
      if ((SSLLibFile) <> '') then
        OSSL_PROVIDER_set_default_search_path(nil, PAnsiChar(ExtractFilePath(SSLLibFile)));

      OSSL_PROVIDER_load(Nil, 'legacy'); // Loading legacy.dll
    end;

{$IFDEF OS2}
    Result := InitEMXHandles;
{$ELSE OS2}
    Result := True;
{$ENDIF OS2}
  finally
    SSLCS.Leave;
  end;
end;

function DestroySSLInterface: Boolean;
begin
  Result:=Not isSSLLoaded;
  if Result then
   exit;
  SSLCS.Enter;
  try
    if assigned(_CRYPTOnumlocks) and assigned(_CRYPTOsetlockingcallback) then
      FreeLocks;
    EVPCleanup;
    CRYPTOcleanupAllExData;
    ErrRemoveState(0);
    ClearUtilEntryPoints;
    ClearSSLEntryPoints;
    UnloadLibraries;
    Result := True;
  finally
    SSLCS.Leave;
  end;
end;


initialization
  SSLCS := TCriticalSection.Create;
  SSLLibPath := '';

finalization
  DestroySSLInterface;
  SSLCS.Free;

end.

