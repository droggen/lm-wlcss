#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ilcssfp.h"

#include "main.h"

#ifndef MATLAB_MEX_FILE
// Return -1 if not enough static memory
int iwlcss_init_static(DTYPE *motif, SIZETYPE motifsize, SIZETYPE winsize, DTYPE penalty, DTYPE reward, DTYPE accepteddist, IWLCSSState *state)
{
    state->oldmatch=(DTYPE*)&__memory[__memoryused];
    __memoryused+=motifsize*sizeof(DTYPE);
    state->btrack=(char*)&__memory[__memoryused];
    __memoryused+=motifsize*winsize*sizeof(char);
    state->motif = motif;
    state->motifsize = motifsize;
    state->winsize=winsize;
    state->penalty=penalty;
    state->reward=reward;
    state->accepteddist=accepteddist;

    if(__memoryused>__memorysize)
        return -1;
    return 0;
}
#endif

void iwlcss_init(DTYPE *motif,SIZETYPE motifsize,SIZETYPE winsize,DTYPE penalty,DTYPE reward,DTYPE accepteddist,IWLCSSState *state)
{
    state->oldmatch=(DTYPE*)malloc(motifsize*sizeof(DTYPE));
    memset(state->oldmatch,0x00,motifsize*sizeof(DTYPE));
    //state->newmatch=(DTYPE*)malloc(motifsize*sizeof(DTYPE));
    state->btrack=(char*)malloc(motifsize*winsize*sizeof(char));              // Organized as btrack[line*winsize + col]
    memset(state->btrack,0x55,motifsize*winsize*sizeof(char));
    state->motif = motif;
    state->motifsize = motifsize;
    state->winsize=winsize;
    state->penalty=penalty;
    state->reward=reward;
    state->accepteddist=accepteddist;
}
#ifdef ENABLEDEBUG
void iwlcss_init_debug(SIZETYPE motifsize,SIZETYPE streamsize,IWLCSSState *state)
{
    state->iteration=0;
    state->streamsize=streamsize;
    state->m1=(DTYPE*)malloc(motifsize*streamsize*sizeof(DTYPE));               // Organized as m1[line*streamsize + col]
    memset(state->m1,0x55,motifsize*streamsize*sizeof(DTYPE));
    state->m2=(DTYPE*)malloc(motifsize*streamsize*sizeof(DTYPE));
    memset(state->m2,0x55,motifsize*streamsize*sizeof(DTYPE));
    state->m3=(DTYPE*)malloc(motifsize*streamsize*sizeof(DTYPE));
    memset(state->m3,0x55,motifsize*streamsize*sizeof(DTYPE));
    state->m=(DTYPE*)malloc(motifsize*streamsize*sizeof(DTYPE));
    memset(state->m,0x55,motifsize*streamsize*sizeof(DTYPE));
    state->allbtrack=(char*)malloc(motifsize*streamsize*sizeof(char));
    memset(state->allbtrack,0x55,motifsize*streamsize*sizeof(char));

}
#endif

// Return the current matching score
/*
DTYPE iwlcss_step(DTYPE newsample,IWLCSSState *state)
{
    DTYPE ml,mu,mul;

    // Shift left the backtrack. Can be optimized with circular buffer
    for(DTYPE j=0;j<state->motifsize;j++)
        for(DTYPE i=0;i<state->winsize-1;i++)
            state->btrack[j*state->winsize+i] = state->btrack[j*state->winsize+i+1];



    for(DTYPE j=0;j<state->motifsize;j++)
    {
        // Find the matching scores of the left, upper and upper left neighbors
        ml = state->oldmatch[j];
        if(j==0)
        {
            mu=0;
            mul=0;
        }
        else
        {
            mu = state->newmatch[j-1];
            mul = state->oldmatch[j-1];
        }

        if( newsample-state->motif[j]>=-state->accepteddist && newsample-state->motif[j]<=state->accepteddist  )
        {
            // Match
            state->newmatch[j] = mul+state->reward;
            state->btrack[j*state->winsize+state->winsize-1] = 0;
            // Debug internals
            state->allbtrack[j*state->streamsize+state->iteration] = 0;
            state->m[j*state->streamsize+state->iteration] = state->newmatch[j];
            state->m1[j*state->streamsize+state->iteration] = state->newmatch[j];
            state->m2[j*state->streamsize+state->iteration] = 0;
            state->m3[j*state->streamsize+state->iteration] = 0;
        }
        else
        {
            DTYPE p = newsample-state->motif[j];
            if(p<0) p=-p;
            p *= state->penalty;
            DTYPE p1 = mul-p;
            DTYPE p2 = mu-p;
            DTYPE p3 = ml-p;
            DTYPE m,pos;
            // Find max
            if(p1>=p2)
            {
                if(p1>=p3)
                {
                    m = p1;
                    pos = 0;
                }
                else
                {
                    m = p3;
                    pos = 2;
                }
            }
            else
            {
                if(p2>=p3)
                {
                    m = p2;
                    pos = 1;
                }
                else
                {
                    m = p3;
                    pos = 2;
                }

            }
            state->newmatch[j] = m;
            state->btrack[j*state->winsize+state->winsize-1] = pos;
            // Debug DTYPEernals
            state->allbtrack[j*state->streamsize+state->iteration] = pos;
            state->m[j*state->streamsize+state->iteration] = m;
            state->m1[j*state->streamsize+state->iteration] = p1;
            state->m2[j*state->streamsize+state->iteration] = p2;
            state->m3[j*state->streamsize+state->iteration] = p3;
        }
    }
    // Debug internals
    state->iteration++;

    DTYPE currentscore = state->newmatch[state->motifsize-1];

    // Set oldmatch to newmatch: can be optimized with poDTYPEer trick
    for(DTYPE j=0;j<state->motifsize;j++)
        state->oldmatch[j] = state->newmatch[j];

    return currentscore;

}
*/
// Return the current matching score
DTYPE iwlcss_step2(DTYPE newsample,IWLCSSState *state)
{


    // Shift left the backtrack. Can be optimized with circular buffer
    for(SIZETYPE j=0;j<state->motifsize;j++)
        for(SIZETYPE i=0;i<state->winsize-1;i++)
            state->btrack[j*state->winsize+i] = state->btrack[j*state->winsize+i+1];



    // Matching scores of the left, upper and upper left neighbors
    DTYPE ml;
    DTYPE mul = 0;
    DTYPE mu = 0;
    DTYPE newmatchcur;



    for(SIZETYPE j=0;j<state->motifsize;j++)
    {
        ml = state->oldmatch[j];

        if( newsample-state->motif[j]>=-state->accepteddist && newsample-state->motif[j]<=state->accepteddist  )
        {
            // Match
            //state->newmatch[j] = mul+state->reward;
            newmatchcur = mul+state->reward;
            state->btrack[j*state->winsize+state->winsize-1] = 0;

#ifdef ENABLEDEBUG
            // Debug internals
            state->allbtrack[j*state->streamsize+state->iteration] = 0;
            //state->m[j*state->streamsize+state->iteration] = state->newmatch[j];
            state->m[j*state->streamsize+state->iteration] = newmatchcur;
            //state->m1[j*state->streamsize+state->iteration] = state->newmatch[j];
            state->m1[j*state->streamsize+state->iteration] = newmatchcur;
            state->m2[j*state->streamsize+state->iteration] = 0;
            state->m3[j*state->streamsize+state->iteration] = 0;
#endif
        }
        else
        {
            DTYPE p = newsample-state->motif[j];
            if(p<0) p=-p;
            p *= state->penalty;
            DTYPE p1 = mul-p;
            DTYPE p2 = mu-p;
            DTYPE p3 = ml-p;
            DTYPE m;
            char pos;
            // Find max
            if(p1>=p2)
            {
                if(p1>=p3)
                {
                    m = p1;
                    pos = 0;
                }
                else
                {
                    m = p3;
                    pos = 2;
                }
            }
            else
            {
                if(p2>=p3)
                {
                    m = p2;
                    pos = 1;
                }
                else
                {
                    m = p3;
                    pos = 2;
                }

            }
            //state->newmatch[j] = m;
            newmatchcur = m;
            state->btrack[j*state->winsize+state->winsize-1] = pos;

#ifdef ENABLEDEBUG
            // Debug internals
            state->allbtrack[j*state->streamsize+state->iteration] = pos;
            state->m[j*state->streamsize+state->iteration] = m;
            state->m1[j*state->streamsize+state->iteration] = p1;
            state->m2[j*state->streamsize+state->iteration] = p2;
            state->m3[j*state->streamsize+state->iteration] = p3;
#endif
        }

        // Commit
        mul = ml;
        mu = newmatchcur;
        state->oldmatch[j] = newmatchcur;


    }
#ifdef ENABLEDEBUG
    // Debug internals
    state->iteration++;
#endif
    return newmatchcur;
}

void dumpmatrix(DTYPE *data,DTYPE sx,DTYPE sy)
{
    for(DTYPE y=0;y<sy;y++)
    {
        for(DTYPE x=0;x<sx;x++)
        {
            printf("% 4d ",data[y*sx+x]);
        }
        printf("\n");
    }
}
void dumpmatrix8(char *data,DTYPE sx,DTYPE sy)
{
    for(DTYPE y=0;y<sy;y++)
    {
        for(DTYPE x=0;x<sx;x++)
        {
            printf("% 4d ",(int)data[y*sx+x]);
        }
        printf("\n");
    }
}
void dump(IWLCSSState *state)
{
    printf("Final scores\n");
#ifdef ENABLEDEBUG
    dumpmatrix(state->m,state->streamsize,state->motifsize);
    printf("M1 scores\n");
    dumpmatrix(state->m1,state->streamsize,state->motifsize);
    printf("M2 scores\n");
    dumpmatrix(state->m2,state->streamsize,state->motifsize);
    printf("M3 scores\n");
    dumpmatrix(state->m3,state->streamsize,state->motifsize);
    printf("Backtrack\n");
    dumpmatrix8(state->allbtrack,state->streamsize,state->motifsize);
#endif
    printf("Sliding window backtrack\n");
    dumpmatrix8(state->btrack,state->winsize,state->motifsize);
}

// The caller must call: iwlcss_free(&state);
IWLCSSState iwlcssfp(DTYPE *motif,SIZETYPE motifsize,DTYPE *stream,SIZETYPE streamsize,DTYPE penalty,DTYPE reward,DTYPE accepteddist,SIZETYPE winsize,DTYPE *out)
{
    IWLCSSState state;
    iwlcss_init(motif,motifsize,winsize,penalty,reward,accepteddist,&state);
#ifdef ENABLEDEBUG
    iwlcss_init_debug(motifsize,streamsize,&state);
#endif

    for(SIZETYPE i=0;i<streamsize;i++)
    {
        DTYPE s = iwlcss_step2(stream[i],&state);
        if(out)
            out[i] = s;
        //printf("% 4d ",s);
    }
    //printf("\n");
    //dump(&state);

    return state;
}

#ifndef MATLAB_MEX_FILE
// The caller must call: iwlcss_free(&state);
IWLCSSState iwlcssfp_static(DTYPE *motif,SIZETYPE motifsize,DTYPE *stream,SIZETYPE streamsize,DTYPE penalty,DTYPE reward,DTYPE accepteddist,SIZETYPE winsize,DTYPE *out)
{
    IWLCSSState state;
    int rv = iwlcss_init_static(motif,motifsize,winsize,penalty,reward,accepteddist,&state);
    if(rv==-1)
    {
        printf("Not enough memory\n");
        return state;
    }
    printf("Memory used now: %u\n",__memoryused);

/*#ifdef ENABLEDEBUG
    iwlcss_init_debug(motifsize,streamsize,&state);
#endif*/

    for(DTYPE i=0;i<streamsize;i++)
    {
        DTYPE s = iwlcss_step2(stream[i],&state);
        if(out)
            out[i] = s;
        //printf("% 4d ",s);
    }
    //printf("\n");
    //dump(&state);

    return state;
}
#endif

void iwlcss_free(IWLCSSState *state)
{
    free(state->oldmatch);
    state->oldmatch=0;
    //free(state->newmatch);
    //state->newmatch=0;
    free(state->btrack);
    state->btrack=0;

#ifdef ENABLEDEBUG
    // Debug internals
    free(state->m1);
    state->m1=0;
    free(state->m2);
    state->m2=0;
    free(state->m3);
    state->m3=0;
    free(state->m);
    state->m=0;
    free(state->allbtrack);
    state->allbtrack=0;
#endif
}
