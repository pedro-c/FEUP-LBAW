<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 5/3/17
 * Time: 2:33 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$projectId = $_SESSION['project_id'];

$numPosts = getNumPosts(array($projectId));
$numPages = ceil($numPosts / 5);

echo $numPages;
