// DllTest.cpp : Definisce le funzioni esportate per la DLL.
//

#include "pch.h"
#include "framework.h"
#include "DllTest.h"


// Esempio di variabile esportata
DLLTEST_API int nDllTest=0;

// Esempio di funzione esportata.
DLLTEST_API int fnDllTest(void)
{
    return 0;
}

// Costruttore di una classe esportata.
CDllTest::CDllTest()
{
    return;
}
