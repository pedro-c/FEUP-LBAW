<?php /* Smarty version Smarty-3.1.15, created on 2017-05-03 18:01:09
         compiled from "/opt/lbaw/lbaw1614/public_html/final/templates/forum/forum.tpl" */ ?>
<?php /*%%SmartyHeaderCode:287908449590a0cd5285759-17001740%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'bddc2a6d335ea95facaaec7b13cb0ea582fe9485' => 
    array (
      0 => '/opt/lbaw/lbaw1614/public_html/final/templates/forum/forum.tpl',
      1 => 1493830862,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '287908449590a0cd5285759-17001740',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'forumPage' => 0,
    'numPages' => 0,
    'i' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_590a0cd52ed582_16137538',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_590a0cd52ed582_16137538')) {function content_590a0cd52ed582_16137538($_smarty_tpl) {?><link href="../css/forum.css" rel="stylesheet">

<div class="page-wrapper container">
    <div class="page-wrapper container">
        <div class="row"><br>
            <div id="forum-posts" class="list-group">
                <div class="forum-posts-nav">
                    <button id="new-post-button" class="list-group-item">
                        <div class="row ">
                            <div id="plus-icon" class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                                <h4 class="glyphicon glyphicon-plus"></h4>
                            </div>
                            <div id="new-content" class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                                <h4 class="list-group-item-heading">Write a new post </h4>
                                <div class="list-group-item-text">
                                    <small>
                                        <span class="post-submission-date">Create a new discussion</span>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </button>

                    <!-- list the posts - to be filled by JS -->
                    <div id="post-listing">
                    </div>

                    <nav aria-label="Page navigation">
                        <div class="text-center">
                            <ul class="pagination">
                                <li id="pagination-prev" <?php if ($_smarty_tpl->tpl_vars['forumPage']->value==1) {?>class="disabled"<?php }?>>
                                    <a href="#" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <span id="pagination-pages">
                                <?php $_smarty_tpl->tpl_vars['i'] = new Smarty_Variable;$_smarty_tpl->tpl_vars['i']->step = 1;$_smarty_tpl->tpl_vars['i']->total = (int) ceil(($_smarty_tpl->tpl_vars['i']->step > 0 ? $_smarty_tpl->tpl_vars['numPages']->value+1 - (1) : 1-($_smarty_tpl->tpl_vars['numPages']->value)+1)/abs($_smarty_tpl->tpl_vars['i']->step));
if ($_smarty_tpl->tpl_vars['i']->total > 0) {
for ($_smarty_tpl->tpl_vars['i']->value = 1, $_smarty_tpl->tpl_vars['i']->iteration = 1;$_smarty_tpl->tpl_vars['i']->iteration <= $_smarty_tpl->tpl_vars['i']->total;$_smarty_tpl->tpl_vars['i']->value += $_smarty_tpl->tpl_vars['i']->step, $_smarty_tpl->tpl_vars['i']->iteration++) {
$_smarty_tpl->tpl_vars['i']->first = $_smarty_tpl->tpl_vars['i']->iteration == 1;$_smarty_tpl->tpl_vars['i']->last = $_smarty_tpl->tpl_vars['i']->iteration == $_smarty_tpl->tpl_vars['i']->total;?>
                                    <?php if ($_smarty_tpl->tpl_vars['i']->value==$_smarty_tpl->tpl_vars['forumPage']->value) {?>
                                    <li class="active"><a><?php echo $_smarty_tpl->tpl_vars['i']->value;?>
</a></li>
                                    <?php } else { ?>
                                    <?php if ($_smarty_tpl->tpl_vars['i']->value==1||$_smarty_tpl->tpl_vars['i']->value==$_smarty_tpl->tpl_vars['numPages']->value||$_smarty_tpl->tpl_vars['i']->value>=$_smarty_tpl->tpl_vars['forumPage']->value-2||$_smarty_tpl->tpl_vars['i']->value<='forumPage'+2) {?>
                                    <li><a><?php echo $_smarty_tpl->tpl_vars['i']->value;?>
</a></li>
                                    <?php }?>
                                    <?php }?>
                                    <?php }} ?>
                                    </span>
                                <li id="pagination-next">
                                    <a href="#" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </div><!-- forum content -->
            </div>
        </div><!-- row -->
    </div>
    <script src="../javascript/forum.js"></script><?php }} ?>
