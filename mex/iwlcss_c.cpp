#include <stdio.h>
#include <malloc.h>
#include <string.h>

#include <mex.h>


#include "ilcssfp/ilcssfp.h"

#define printf mexPrintf




void Syntax()
{
	printf("Parameters: motif, stream, penalty, reward, accepteddist,winsize\n");
    printf("Return: [match,btrackwinsize,allbtrack,m1,m2,m3]\n");
}
void Error(char *s)
{
	mexErrMsgTxt(s);
}

void copyshorttranspose(short *carray,short *matlabarray,int sx,int sy)
{
    for(int x=0;x<sx;x++)
    {
        for(int y=0;y<sy;y++)
        {
            matlabarray[x*sy+y] = carray[y*sx+x];           
        }
    }
}
void copychartranspose(char *carray,char *matlabarray,int sx,int sy)
{
    for(int x=0;x<sx;x++)
    {
        for(int y=0;y<sy;y++)
        {
            matlabarray[x*sy+y] = carray[y*sx+x];           
        }
    }
}


// Parameters: motif, stream, penalty, reward, winsize
void mexFunction( int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[] )
{
	// Check in/out args
	//if(nrhs!=1 || nlhs!=1)
    if(nrhs!=6)
	{
		Syntax();
		Error("Invalid number of parameters");
	}
	
    // Check params: must all be int8
    
    
	if(mxGetClassID(prhs[0]) != mxINT16_CLASS)
	  Error("Error: motif mut be int16");
    if(mxGetM(prhs[0])!=1)
        Error("Error: motif must be row vector");
    if(mxGetClassID(prhs[1]) != mxINT16_CLASS)
	  Error("Error: stream mut be int16");
    if(mxGetM(prhs[1])!=1)
        Error("Error: stream must be row vector");
    if(mxGetClassID(prhs[2]) != mxINT16_CLASS)
	  Error("Error: penalty mut be int16");
    if(mxGetClassID(prhs[3]) != mxINT16_CLASS)
	  Error("Error: reward mut be int16");
    if(mxGetClassID(prhs[4]) != mxINT16_CLASS)
	  Error("Error: accepteddist mut be int16");
    if(mxGetClassID(prhs[5]) != mxINT16_CLASS)
	  Error("Error: winsize mut be int16");
	
	short penalty,reward,winsize;
    short *motif;
    SIZETYPE motifsize;
    short *stream;
    SIZETYPE streamsize;
    short accepteddist;
    
    motif = (short*)mxGetData(prhs[0]);
    motifsize = (SIZETYPE)mxGetN(prhs[0]);
    stream = (short*)mxGetData(prhs[1]);
    streamsize = (SIZETYPE)mxGetN(prhs[1]);
    penalty = *(short*)mxGetData(prhs[2]);
    reward = *(short*)mxGetData(prhs[3]);
    accepteddist = *(short*)mxGetData(prhs[4]);
    winsize = *(short*)mxGetData(prhs[5]);
    
    /*printf("Penalty: %d. Reward: %d. Winsize: %d\n",penalty,reward,winsize);
    printf("Motif at %p, length %d\n",motif,motifsize);
    printf("Stream at %p, length %d\n",stream,streamsize);*/
    
    // Ready to process data
    
    IWLCSSState state = iwlcssfp(motif,motifsize,stream,streamsize,penalty,reward,accepteddist,winsize,0);

   
    
    // Create the matlab return values
    // Return: [match,btrackwinsize,allbtrack,m1,m2,m3]
    
    
    if(nlhs<1)
	{
		Syntax();
		Error("Error: Minimum one output parameter");
	}
    if(nlhs>6)
	{
		Syntax();
		Error("Error: Maximum 6 output parameter");
	}
    
    mwSize dims[2];

    // Return matching
    dims[0] = motifsize;
    dims[1] = streamsize;
    plhs[0] = mxCreateNumericArray(2,dims,mxINT16_CLASS,mxREAL);
    short *out = (short*)mxGetData(plhs[0]);
    copyshorttranspose(state.m,out,streamsize,motifsize);
    
    
    if(nlhs>=2)
    {
        // Return windowed backtrack
        dims[0] = motifsize;
        dims[1] = winsize;
        plhs[1] = mxCreateNumericArray(2,dims,mxINT8_CLASS,mxREAL);
        char *outc = (char*)mxGetData(plhs[1]);
        copychartranspose(state.btrack,outc,winsize,motifsize);
    }
    
    if(nlhs>=3)
    {
        // Return all backtrack
        dims[0] = motifsize;
        dims[1] = streamsize;
        plhs[2] = mxCreateNumericArray(2,dims,mxINT8_CLASS,mxREAL);
        char *outc = (char*)mxGetData(plhs[2]);
        copychartranspose(state.allbtrack,outc,streamsize,motifsize);
    }
    
    if(nlhs>=4)
    {
         // Return m1
        dims[0] = motifsize;
        dims[1] = streamsize;
        plhs[3] = mxCreateNumericArray(2,dims,mxINT16_CLASS,mxREAL);
        out = (short*)mxGetData(plhs[3]);
        copyshorttranspose(state.m1,out,streamsize,motifsize);
    }
    
    if(nlhs>=5)
    {
        // Return m2
        dims[0] = motifsize;
        dims[1] = streamsize;
        plhs[4] = mxCreateNumericArray(2,dims,mxINT16_CLASS,mxREAL);
        out = (short*)mxGetData(plhs[4]);
        copyshorttranspose(state.m2,out,streamsize,motifsize);
    }
    
    if(nlhs>=6)
    {
        // Return m3
        dims[0] = motifsize;
        dims[1] = streamsize;
        plhs[5] = mxCreateNumericArray(2,dims,mxINT16_CLASS,mxREAL);
        out = (short*)mxGetData(plhs[5]);
        copyshorttranspose(state.m3,out,streamsize,motifsize);        
    }
    
    iwlcss_free(&state);   
}





