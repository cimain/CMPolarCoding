#include "mex.h"
#include "math.h"
#include "stdlib.h"
int sign(double x)
{
    return( (x>0)?1:((x<0)?(-1):0) );
}
double min(double a,double b)
{
    if ( a>= b)
        return b;
    else
        return a;
}
double Gen_f_C(int N,int i,double *y0,int *ui,double sigma)
{
    int j=0;
    int k=0;
    double f=0;
    if(N==1)
    {
        f=2*y0[0]/(sigma*sigma);
		return f;
    }
    else
    {
        int k1=0;
        double L1=0;
        double L2=0;
        int *ue;
        int *uo;
        int *uoe;
        double *y1;
        double *y2;
        if (i%2==1)
        {
            ue=new int[(i-1)/2];
            uo=new int[(i-1)/2];
            uoe=new int[(i-1)/2];
            y1=new double[N/2];
            y2=new double[N/2];
            for(j=0;j<i-1;j=j+2,k++) //i=5,ui=0:3 
            {
                uo[k]=ui[j];
                ue[k]=ui[j+1];
                uoe[k]=uo[k]+ue[k];      
            }
            for(j=0;j<N/2;j++,k1++) //N=256,N/2=128; 1:128 129:256
            {
                y1[k1]=y0[j];
                y2[k1]=y0[N/2+j];
            }
            L1=Gen_f_C(N/2,(i+1)/2,y1,uoe,sigma);
            L2=Gen_f_C(N/2,(i+1)/2,y2,ue,sigma);
            f=sign(L1*L2)*min(fabs(L1),fabs(L2));
//             f=sign( Gen_f_C(N/2,(i+1)/2,y1,uoe,sigma) * Gen_f_C(N/2,(i+1)/2,y2,ue,sigma) ) * min( fabs(Gen_f_C(N/2,(i+1)/2,y1,uoe,sigma)),fabs(Gen_f_C(N/2,(i+1)/2,y2,ue,sigma) ));
        }
        else  // mod(i,2)==0
        {
            ue=new int[(i-2)/2];
            uo=new int[(i-2)/2];
            uoe=new int[(i-2)/2];
            y1=new double[N/2];
            y2=new double[N/2];
            for(j=0;j<i-2;j=j+2,k++) //i=2,ui=0:0 
            {
                uo[k]=ui[j];
                ue[k]=ui[j+1];
                uoe[k]=uo[k]+ue[k];       
            }
            for(j=0;j<N/2;j++,k1++) //N=256,N/2=128; 1:128 129:256
            {
                y1[k1]=y0[j];
                y2[k1]=y0[N/2+j];
            }
            L1=Gen_f_C(N/2,i/2,y1,uoe,sigma);
            L2=Gen_f_C(N/2,i/2,y2,ue,sigma);
            f=pow((double)-1,ui[i-2])*L1+L2;
//             f=pow(-1,ui[i-2])*Gen_f_C(N/2,i/2,y1,uoe,sigma) + Gen_f_C(N/2,i/2,y2,ue,sigma);
        }    
        delete[] ue;
        delete[] uo;
        delete[] uoe;
        delete[] y1;
        delete[] y2;
    }
 
   // return f;
}
//***********************************************************
void mexFunction( int nlhs, mxArray *plhs[],
    int nrhs, const mxArray*prhs[] )
{
    double PM_i_1=mxGetPr(prhs[0])[0];   //length=1
    int N=(int)mxGetPr(prhs[1])[0];       //length=1
    int i=(int)mxGetPr(prhs[2])[0];       //length=1
    double *y0=mxGetPr(prhs[3]);     //length=1;N
    double *ui=mxGetPr(prhs[4]);     //length=1:i-1
    double u=mxGetPr(prhs[5])[0];    //length=1
    double *z=mxGetPr(prhs[6]);      //length=1:N
    double sigma=mxGetPr(prhs[7])[0];//length=1
    
    double *PM;
    double f;
    int k=0;
    int *int_ui;
    int_ui=(int*)malloc(sizeof(int)*(i-1));
    for(k=0;k<i-1;k++)
    {
        int_ui[k]=(int)ui[k];
    }  
    plhs[0]=mxCreateDoubleMatrix(1,1, mxREAL);
    PM=mxGetPr(plhs[0]);
    f=Gen_f_C(N,i,y0,int_ui,sigma);
    
    free(int_ui);
    int_ui=NULL;

    if(z[i-1]==0 && u==1) 
    {
        PM[0]=-2147483647 - 1; //-2^32/2-1 double=4 byte =32 bit
    }
    else
    {
        if ( (z[i-1]==1 || u==0) && 1-2*u == sign(f) ) //sign(f)=(f>0)?1:((f<0)?(-1):0)
            PM[0]=PM_i_1;
        else
            PM[0]=PM_i_1-fabs(f);     //fabs(x) 
    }
    return;
}    
 
    

