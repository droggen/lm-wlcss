#ifndef ILCSSFP_H
#define ILCSSFP_H

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#define printf mexPrintf
#endif

#define DTYPE short
#define SIZETYPE unsigned int

#define ENABLEDEBUG

typedef struct
{
    DTYPE *oldmatch;
    //DTYPE *newmatch;
    char *btrack;
    DTYPE penalty;
    DTYPE reward;
    DTYPE *motif;
    SIZETYPE motifsize;
    SIZETYPE winsize;
    DTYPE accepteddist;

    // Debug stuff here
#ifdef ENABLEDEBUG
    SIZETYPE iteration;
    SIZETYPE streamsize;
    DTYPE *m1,*m2,*m3,*m;
    char *allbtrack;
#endif
} IWLCSSState;

#ifndef MATLAB_MEX_FILE
int iwlcss_init_static(DTYPE *motif, SIZETYPE motifsize, SIZETYPE winsize, DTYPE penalty, DTYPE reward, DTYPE accepteddist, IWLCSSState *state);
#endif
void iwlcss_init(DTYPE *motif, SIZETYPE motifsize, SIZETYPE winsize, DTYPE penalty, DTYPE reward, DTYPE accepteddist, IWLCSSState *state);
#ifdef ENABLEDEBUG
void iwlcss_init_debug(SIZETYPE motifsize,SIZETYPE streamsize,IWLCSSState *state);
#endif
//DTYPE iwlcss_step(DTYPE newsample,IWLCSSState *state);
DTYPE iwlcss_step2(DTYPE newsample,IWLCSSState *state);
void dumpmatrix(DTYPE *data,DTYPE sx,DTYPE sy);
void dumpmatrix8(char *data,DTYPE sx,DTYPE sy);
void dump(IWLCSSState *state);
IWLCSSState iwlcssfp(DTYPE *motif, SIZETYPE motifsize, DTYPE *stream, SIZETYPE streamsize, DTYPE penalty, DTYPE reward, DTYPE accepteddist, SIZETYPE winsize, DTYPE *out);
IWLCSSState iwlcssfp_static(DTYPE *motif,SIZETYPE motifsize,DTYPE *stream,SIZETYPE streamsize,DTYPE penalty,DTYPE reward,DTYPE accepteddist,SIZETYPE winsize,DTYPE *out);
void iwlcss_free(IWLCSSState *state);




#endif // ILCSSFP_H
