<?php

namespace WebBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class GameController extends Controller
{

    public function indexAction(Request $request)
    {
        $em = $this->getDoctrine()->getManager();
        $order =  $request->get('order');

        $nombre = 30;
        $em = $this->getDoctrine()->getManager();
        $repository = $em->getRepository('AppBundle:Game');

        $dir = "DESC";
        if ($order == "title") {
            $dir = "ASC";
        } elseif ($order == "newest") {
            $order = "created";
        }

        $repo_query = $repository->createQueryBuilder('p');
        $repo_query->where("1 = 1");

        $repo_query->addOrderBy('p.'.$order, $dir);
        $repo_query->addOrderBy('p.id', 'ASC');

        $query =  $repo_query->getQuery(); 

        $paginator = $this->get('knp_paginator');
        $games = $paginator->paginate(
            $query,
            $request->query->getInt('page', 1),
            42
        );

        return $this->render('WebBundle:Game:index.html.twig',
            array(
                "games"=>$games
            )
        );
    }
}
