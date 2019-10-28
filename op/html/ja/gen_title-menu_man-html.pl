#!C:/Perl/bin/perl.exe
#!/usr/bin/env perl

use strict;

#use encoding 'cp932';
#use open OUT => ":utf8"; # ����write open�����t�@�C���ւ̏o�͂�UTF8�Ƃ���
#binmode STDOUT, ':encoding(shift-jis)';
#binmode STDERR, ':encoding(shift-jis)';

use Data::Dumper;
#{
#  package Data::Dumper;
#  sub qquote {return shift;}
#}
#$Data::Dumper::Useperl = 1;


=head1 ���O

gen_title-menu_man-html.pl - title.html��menu_man.html�̐���

=head1 �T�v

���g�|�O���t�B��̓\�t�g�̃I�����C���}�j���A����html�t�@�C���̂���
PDF�t�@�C���ւ̃����N���܂�title.html�ƃc���[���j���[�̂��߂�
menu_man.html�ɍ������ރ����N�������������A
���ꂼ���html�t�@�C�����J�����g�f�B���N�g���ɏo�͂���B

����script�����s���邽�߂ɂ�Windows��perl�����n���C���X�g�[������Ă���K�v������B
����m�F���s����perl�����n��ActiveState��ActivePerl 5.12.2�ł���B

=head1 ����

PDF�t�@�C���͂���script�����s����O�ɓ����f�B���N�g���Ɋi�[���Ă����B

script�̎��s��Windows����script�t�@�C�����_�u���N���b�N�A�܂��̓R���\�[������
perl�����n��script�����s����B

�o�͂����html�Ɠ������O�̃t�@�C�����J�����g�f�B���N�g���ɂ������ꍇ�ɂ�
html�t�@�C�����ɃT�t�B�b�N�X.bak��t���ĕۑ�����B

�`���v�^�[�ԍ�����уZ�N�V�����ԍ���PDF�t�@�C���ւ̃����N�̑Ή��́A
����script�̖�����__DATA__�Z�N�V������
�`���v�^�[�ԍ��A�Z�N�V�����ԍ��A�^�C�g���A�p�X���^�u�ŋ�؂��ċL�q����B
�p�X���ȗ�����Ă���ꍇ�A�����N�̃A���J�[���ȗ�����A�̓^�C�g���̕�����݂̂��\�������B

�p�X���L�q���ꂢ�邪�A���̃p�X��PDF�t�@�C�������݂��Ȃ��ꍇ�́A
�R���\�[���Ƀ��[�j���O���o�͂���A���̏ꍇ�������N�̃A���J�[���ȗ������B
�_�u���N���b�N��script�����s�����ꍇ�́A���[�j���O����u�����\�������B

�Ȃ��A�Z�N�V�����ԍ�0�̓`���v�^�[��\���B
�܂��A�Z�N�V�������ЂƂ������Ȃ��`���v�^�[�����̏͂�PDF����舵����B

=back

=cut

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# �f�[�^�Ǎ� (�͗���/ �y�[�W���)
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
my %index;
my ($chapt, $sect, $title, $path, $page);
for (<DATA>) {
  chomp;
  ($chapt, $sect, $title, $path, $page) = (split('\t'))[0,1,2,3,4];
  $title =~ s/ /\&nbsp;/g;
  $index{$chapt}{$sect} = {title => $title, path => $path, page => $page};
  ($path and ! -f $path) and
    warn "Warning: file `$path' not found: $!\n"
}

#print Dumper \%index;


use CGI qw/-no_xhtml/;
my $q = new CGI;
### $q->charset('utf-8');


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
### title.html ###
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
my $file = 'title.html';
rename $file, "./back/${file}.bak"; # backup original file

open(TITLE, "> $file")
  or die "Couldn't open `$file' for writing:";

# --------------------------------------
# �t�@�C�� (TITLE) �� �w�b�_�����o��
# --------------------------------------
#print TITLE $q->header; # not output HTTP responce header

print TITLE $q->start_html(-title => 'Platform for Optical Topography Analysis Tools',
			   -lang => 'ja',
			   -head => [$q->meta({-http_equiv => 'Content-Type',
					       -content    => 'text/html; charset=Shift_JIS'}),
				     '<base target="main">'],
			   -style => {-src => './matlab_like.css'},
			   -script => {-type => 'JavaScript', -src => './changeScript.js'}
			  );

# --------------------------------------
# �^�C�g�����������o��
# --------------------------------------
print TITLE $q->start_table({border=>0, width=>"100%", cellspacing=>"0"}), "\n";
#print TITLE $q->start_table({border=>0,  cellspacing=>"0"}), "\n";
print TITLE <<END;
  <!-- Title -->
  <tr class="mattitle"><td colspan="2">
    <h1 class="mattitle">
      Platform for Optical Topography Analysis Tools
    </h1>
  </td></tr>
  <!-- Link -->
  <tr class="section_lk"><td width="4%"></td><td>
END

# --------------------------------------
# �� & Link ���������o��
# --------------------------------------
for $chapt (sort {$a <=> $b} keys %index) {
  my $chapter = $index{$chapt}{0};
  print TITLE "    ";
  if ($chapter->{path} and -f $chapter->{path}) {
    #print TITLE $q->a({href=>"$chapter->{path}"}, "$chapt.&nbsp;$chapter->{title}")
    print TITLE $q->a({href=>"$chapter->{path}"}, "$chapter->{title}")
  } else {
    #print TITLE "$chapt.&nbsp;$chapter->{title}"
    print TITLE "$chapter->{title}"    
  }
  print TITLE "&nbsp;&nbsp;\n"
}

print TITLE <<END;
  </td></tr>
END
print TITLE $q->end_table;

print TITLE $q->end_html;
close TITLE;

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
### menu-man.html ###
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
my $file = 'menu_man.html';
rename $file, "./back/${file}.bak"; # backup original file

open(MENU_MAN, "> $file")
  or die "Couldn't open `$file' for writing:";

# --------------------------------------
# �t�@�C�� (MENU_MAN) �� �w�b�_�����o��
# --------------------------------------
#print MENU_MAN $q->header; # not output HTTP responce header

print MENU_MAN <<END;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//JA">
<html lang="ja">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">

  <link rel="stylesheet" type="text/css" href="./matlab_like.css">
  <link rel="stylesheet" type="text/css" href="./menu0.css">

  <script type="text/JavaScript" src="./changeScript.js"></script>
  <script type="text/JavaScript" src="./menu.js"></script>
  <title>Platform for Optical Topography Analysis Tools</title>
    
  <base target="main">
</head>
<body style="margin-top:0;padding-top:0;">
<!--  Title -->
<table class="nonespace" border=0 cellspacing="0" cellpadding="0" style="height:100%;">
  <tr><td class="mattitle_">&nbsp;</td><td class="menusize">
  <br><br>
  <ul class="listnone">

END
#<body style="margin:0;padding:0;">

for $chapt (sort {$a <=> $b} keys %index) {
  # --------------------------------------
  # �`���v�^�[�����o��
  # --------------------------------------
  my $chapter = $index{$chapt}{0};

  print MENU_MAN <<END;
    <!-- $chapter->{title} -->
    <li id="mancap$chapt" class="mancap">
END

  if ($chapter->{path} and -f $chapter->{path}) {
    # �����N�L
    print MENU_MAN <<END;
      <div class="plus"  id="plus$chapt">
         <img src="./plus.gif" alt="+" title=""  onClick="mansecOn($chapt);">
         <a href="$chapter->{path}">
            <span class="menu_chapter">$chapter->{title}</span>
         </a>
      </div>
      <div class="minus"  id="minus$chapt">
         <img src="./minus.gif" alt="-" title="" onClick="mansecOff($chapt);">
         <a href="$chapter->{path}">
            <span class="menu_chapter">$chapter->{title}</span>
         </a>
      </div>
END
  } else {
    # �����N��
    print MENU_MAN <<END;
      <div class="plus"  id="plus$chapt">
         <img src="./plus.gif" alt="+" title=""  onClick="mansecOn($chapt);">
         <span class="menu_chapter">$chapter->{title}</span>
      </div>
      <div class="minus"  id="minus$chapt">
         <img src="./minus.gif" alt="-" title="" onClick="mansecOff($chapt);">
         <span class="menu_chapter">$chapter->{title}</span>
      </div>
END
  }


  # --------------------------------------
  # open section
  # --------------------------------------
  print MENU_MAN <<END;
      <!-- Section -->
      <div id="mansec$chapt" class="mansec">
END

  # for each section
  my @sects = sort {$a <=> $b} keys %{$index{$chapt}};
  for $sect (@sects) {
    next if $sect == 0; # skip chapter
    my $section = $index{$chapt}{$sect};

    print MENU_MAN "      <ol>\n" if $sect == 1;

    # sections
    if ($section->{path} and -f $section->{path}) {
      if ($section->{page}){
        print MENU_MAN <<END;
          <li><a href="$section->{path}#page=$section->{page}">
            <span class="menu_section">$section->{title}</span>
          </a></li>
END
      } else {
        print MENU_MAN <<END;
          <li><a href="$section->{path}">
             <span class="menu_section">$section->{title}</span>
          </a></li>
END
      }
    } else {
      print MENU_MAN <<END;
        <li><span class="menu_section">$section->{title}</span></li>
END
    }

    print MENU_MAN "      </ol>\n" if $sect == $#sects;
  }

# close section
#if ($sect == $#sects) {
#  print MENU_MAN <<END;
#     </ol>
#END
#}

# close chapter
print MENU_MAN <<END;
      </div><br>
    </li>

END
}

# final
print MENU_MAN <<END;
  </ul>
  </td></tr>
END

print MENU_MAN $q->end_table;

print MENU_MAN $q->end_html;
close MENU_MAN;


__DATA__
1	0	�T�v	Abstract.pdf
1	1	���g�|�O���t�B�Ƃ�	Abstract.pdf	2
1	2	POTATo�Ƃ�	Abstract.pdf	3
1	3	�J�n���@	Abstract.pdf	5
1	4	��͊T�v	Abstract.pdf	6
1	5	���p����	Abstract.pdf	7
2	0	��{����	BasicOperation.pdf
2	1	��̗͂���	BasicOperation.pdf	3
2	2	POTATo�̃f�[�^�`��	BasicOperation.pdf	6
2	3	�����f�[�^�̓Ǎ��ƊǗ�	BasicOperation.pdf	15
2	4	�f�[�^�I���ƌ����@�\	BasicOperation.pdf	20
2	5	���C���E�B���h�E ���j���[	BasicOperation.pdf	23
3	0	�g������	ExSearch.pdf
3	1	������@	ExSearch.pdf	2
3	2	�������{��	ExSearch.pdf	7
4	0	�X�e�b�v�K�C�h	Step-Guide.pdf
4	1	��͂��Ă݂悤	Step-Guide.pdf	3
4	2	��͕��@�̐ݒ�	Step-Guide.pdf	10
5	0	Normal-Mode	Normal-Mode.pdf
5	1	�T�v	Normal-Mode.pdf	2
5	2	�P������f�[�^�̉��	Normal-Mode.pdf	5
5	3	���������f�[�^�̉��	Normal-Mode.pdf	7
6	0	Research-Mode	Research-Mode.pdf
6	1	�T�v	Research-Mode.pdf	3
6	2	��͏���	Research-Mode.pdf	7
6	3	�v�񓝌v�ʂ̎Z�o	Research-Mode.pdf	21
6	4	���v�I���� 	Research-Mode.pdf	28
7	0	�ʒu�ݒ�	PositionSetting.pdf
7	1	�T�v	PositionSetting.pdf	2
7	2	�ʒu���̐ݒ�	PositionSetting.pdf	3
8	0	�\���@�\	LayoutEditor.pdf
8	1	�T�v	LayoutEditor.pdf	3
8	2	POTATo�̕\���@�\	LayoutEditor.pdf	5
8	3	Layout�̎g����	LayoutEditor.pdf	7
8	4	�\���@�\�g��	LayoutEditor.pdf	22
9	0	��͂̊g��	RecipeDevelopment.pdf
9	1	��͋@�\	RecipeDevelopment.pdf	2
9	2	�f�[�^�\��	RecipeDevelopment.pdf	3
9	3	�t�B���^�̊g��	RecipeDevelopment.pdf	5
9	4	�⏕�֐�	RecipeDevelopment.pdf	12
10	0	�t�^�F�t�B���^�v���O�C��	Filter.pdf
11	0	�t�^:Malab�̊�{����	MATLAB.pdf
12	0	FAQ	FAQ.pdf
13	0	�p��W	P3_Words.html
