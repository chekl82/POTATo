#include <process.h>
#include <windows.h>
#include "mex.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
  	STARTUPINFO si;// �X�^�[�g�A�b�v���
    PROCESS_INFORMATION pi;// �v���Z�X���
    char *bin_file;//

   /* Check num of arg */
  if (nrhs!=1){
    mexErrMsgTxt("Errnor 1");
  } else if (nlhs > 1){
    mexErrMsgTxt("Error : Too many arg");
  }

	bin_file = calloc(1024, sizeof(char));
	bin_file = mxArrayToString(prhs[0]);
//	mexErrMsgTxt(bin_file);
//	return;
	//STARTUPINFO �\���̂̓��e���擾 
	GetStartupInfo(&si);

	//�����Ȃ���ԂŋN��������ɂ́A
	//si.dwFlags = STARTF_USESHOWWINDOW;
	//si.wShowWindow = SW_HIDE;

	CreateProcess(
			NULL,					// ���s�\���W���[���̖��O
			bin_file,				// ���s����t�@�C����
			NULL,					// �Z�L�����e�B�L�q�q
			NULL,					// �Z�L�����e�B�L�q�q
			FALSE,					// �n���h���̌p���I�v�V����
			0,						// �쐬�̃t���O 
			NULL,					// �V�������u���b�N
			NULL,					// �J�����g�f�B���N�g���̖��O
			&si,					// �X�^�[�g�A�b�v���
			&pi					// �v���Z�X���
			);

	//�v���Z�X�̏I����ҋ@����
	//CloseHandle(pi.hThread);
	//WaitForSingleObject(pi.hProcess,INFINITE);
	//CloseHandle(pi.hProcess);

	//return pi.hProcess;
}
