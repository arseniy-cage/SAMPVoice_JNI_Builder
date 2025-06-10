// -- -- -- -- -- -- -- 
// by Weikton 
// -- -- -- -- -- -- --
#include "CNetwork.h"
#include <stdint.h>

#include "util/CJavaWrapper.h"

const char* g_szServerNames[MAX_SERVERS] = {
	"BLACK MOSCOW | RED",
	"BLACK RUSSIA | TEST"
};

const CSetServer::CServerInstanceEncrypted g_sEncryptedAddresses[MAX_SERVERS] = {
	CSetServer::create("185.189.15.22", 1, 16, 7290, false),
	CSetServer::create("185.189.15.22", 1, 16, 7290, false)
};
