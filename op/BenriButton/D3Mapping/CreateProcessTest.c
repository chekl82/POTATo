#include <process.h>
#include <windows.h>
#include "mex.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
  	STARTUPINFO si;// スタートアップ情報
    PROCESS_INFORMATION pi;// プロセス情報

   /* Check num of arg */
  if (nrhs!=0){
    mexErrMsgTxt("Errnor 1");
  } else if (nlhs > 1){
    mexErrMsgTxt("Error : Too many arg");
  }

	//STARTUPINFO 構造体の内容を取得 
	GetStartupInfo(&si);

	//見えない状態で起動させるには、
	//si.dwFlags = STARTF_USESHOWWINDOW;
	//si.wShowWindow = SW_HIDE;

	CreateProcess(
			NULL,					// 実行可能モジュールの名前
			"./bin/Brain_HeadSurfaceGUI.exe",
			NULL,					// セキュリティ記述子
			NULL,					// セキュリティ記述子
			FALSE,					// ハンドルの継承オプション
			0,						// 作成のフラグ 
			NULL,					// 新しい環境ブロック
			NULL,					// カレントディレクトリの名前
			&si,					// スタートアップ情報
			&pi					// プロセス情報
			);

	//プロセスの終了を待機する
	//CloseHandle(pi.hThread);
	//WaitForSingleObject(pi.hProcess,INFINITE);
	//CloseHandle(pi.hProcess);

	//return pi.hProcess;
}
