<?php

namespace WebBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class SerieController extends Controller
{

    public function indexAction(Request $request)
    {
        $em = $this->getDoctrine()->getManager();
        $order =  $request->get('order');
        $genre =  $request->get('genre');

        $genre = $em->getRepository('AppBundle:Genre')->findOneBy(array("title"=>$request->get('genre')));

        $nombre = 30;
        $em = $this->getDoctrine()->getManager();
        $imagineCacheManager = $this->get('liip_imagine.cache.manager');
        $repository = $em->getRepository('AppBundle:Poster');


        $dir = "DESC";
        if($order == "title"){
            $dir="ASC";
        }elseif ($order == "newest") {
            $order = "created";
        }
        $repo_query = $repository->createQueryBuilder('p');
        $repo_query->where("p.enabled = true");

        if ($genre != null) {
                $repo_query->leftJoin('p.genres', 'g');
                $repo_query->andWhere('g.id = ' . $genre->getId());
        }

        $repo_query->andWhere("p.type like 'serie'");
        

        $repo_query->addOrderBy('p.'.$order, $dir);
        $repo_query->addOrderBy('p.id', 'ASC');

        $query =  $repo_query->getQuery(); 
        $paginator = $this->get('knp_paginator');
        $posters = $paginator->paginate(
            $query,
            $request->query->getInt('page', 1),
            42
        );

        $genres = $em->getRepository('AppBundle:Genre')->findAll();

        return $this->render('WebBundle:Serie:index.html.twig',
            array(
                "posters"=>$posters,
                "genres"=>$genres
            )
        );
    }
    public function viewAction($id,$slug)
    {       
        $em = $this->getDoctrine()->getManager();
        $settings = $em->getRepository('AppBundle:Settings')->findOneBy(array());
        $poster = $em->getRepository('AppBundle:Poster')->findOneBy(array("id"=>$id,"slug"=>$slug,"enabled"=>true,"type"=>"serie"));
        if ($poster == null) {
        	
        }

        $favorited =  false;
        if ($this->getUser()!=null) {
           $item = $em->getRepository("AppBundle:Item")->findOneBy(array("user"=>$this->getUser(),"poster" => $poster));
           if ($item!= null) {
               $favorited =  true;
           }
       }
        $comments = $em->getRepository('AppBundle:Comment')->findBy(array("poster"=>$poster),array("created"=>"asc"));
        $ratings = $em->getRepository('AppBundle:Rate')->findBy(array("poster"=>$poster),array("created"=>"asc"));

        $genres="";
        foreach ($poster->getGenres() as $key => $genre) {
        	$genres .= ",".$genre->getId();
        }
        $genres = trim($genres,",");
        $nombre = 20;
        $genres=($genres=="")? "0":$genres;
        $repository = $em->getRepository('AppBundle:Poster');
        $query = $repository->createQueryBuilder('p')
            ->leftJoin('p.genres', 'g')
            ->where("p.enabled = true","p.type like 'serie' ",'g.id in ('.$genres.')')
            ->addSelect('RAND() as HIDDEN rand')
            ->orderBy('rand')
            ->setMaxResults($nombre)
            ->getQuery();
        $related_posters = $query->getResult();

        return $this->render('WebBundle:Serie:view.html.twig',array(
            "poster" => $poster,
            "comments"=>$comments,
            "ratings"=>$ratings,
            "related_posters"=>$related_posters,
            "favorited"=>$favorited,
            "settings"=>$settings
        ));
    }
    public function subtitlesAction($id)
    {       
        $em = $this->getDoctrine()->getManager();

        $episode = $em->getRepository('AppBundle:Episode')->find($id);

        return $this->render('WebBundle:Serie:subtitles.html.twig',array(
            "episode"=>$episode
        ));
    }
    public function downloadsAction($id)
    {       

        $em = $this->getDoctrine()->getManager();
        $repository = $em->getRepository('AppBundle:Source');
        $repo_query = $repository->createQueryBuilder('c');
        $repo_query->leftJoin('c.episode', 'p');
        $repo_query->where("p.id = ". $id ,"c.kind like 'download' or c.kind like 'both' " );

        $query =  $repo_query->getQuery(); 
        $sources = $query->getResult();
        $premium =  false;
        if ($this->getUser()!=null) {
           $premium = $this->getUser()->isSubscribed();
       }
        return $this->render('WebBundle:Serie:downloads.html.twig',array(
            "sources"=>$sources,
            "premium" => $premium
        ));
    }
    public function episodesAction($id)
    {       
        $em = $this->getDoctrine()->getManager();
      	$season = $em->getRepository('AppBundle:Season')->findOneBy(array("id"=>$id));
        if ($season == null) {
        	
        }
      	$episodes = $em->getRepository('AppBundle:Episode')->findBy(array("season"=>$season));

        return $this->render('WebBundle:Serie:episodes.html.twig',array(
            "episodes"=>$episodes
        ));
    }

}
