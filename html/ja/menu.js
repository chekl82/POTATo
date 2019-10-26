function mansecOn(chapid){
  disablevisibile('plus' +chapid);
  enablevisibile('mansec' +chapid);
  enablevisibile('minus' +chapid);
}

function mansecOff(chapid){
  enablevisibile('plus' +chapid);
  disablevisibile('mansec' +chapid);
  disablevisibile('minus' +chapid);
}
/*==========================================
 *�@�c�[��
 * enablevisibile(id) : �w�� ID �̃I�u�W�F�N�g��\��
 * disablevisibile(id) : �w�� ID �̃I�u�W�F�N�g���B��
 *==========================================*/
/* on �p�̊֐� */
function enablevisibile(id){
  /* Change Visible on */
  if (document.getElementById) {
    document.getElementById(id).style.display='block';
  } else if (document.all) {
   with (document.all(id).style) {
	visibility='visible';
	position='relative';
   }
  } else if (document.layers) {
   with (document.layters[id]) {
	hidden=false;
   }
  }
}

/* off �p�̊֐� */
function disablevisibile(id){
  if (document.getElementById) {
    document.getElementById(id).style.display='none';
  } else if (document.all) {
   with (document.all(id).style) {
	visibility='hidden';
	position='absolute';
   }
  } else if (document.layers) {
   with (document.layters[id]) {
	hidden=true;
   }
  }
}

