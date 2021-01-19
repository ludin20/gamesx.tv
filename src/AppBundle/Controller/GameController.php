<?php 
namespace AppBundle\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use AppBundle\Entity\Game;
use MediaBundle\Entity\Media;
use AppBundle\Form\GameType;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\Encoder\XmlEncoder;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;

use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;

class GameController extends Controller
{
    public function indexAction(Request $request)
    {
        $em = $this->getDoctrine()->getManager();
        $games = $em->getRepository("AppBundle:Game")->findBy(array(),array("position"=>"asc"));

        $q="( 1=1 )";
        if ($request->query->has("q") and $request->query->get("q")!="") {
           $q.= " AND ( u.title like '%".$request->query->get("q")."%') ";
        }

        $dql = "SELECT u FROM AppBundle:Game u  WHERE " .$q ." ";
        $query = $em->createQuery($dql);
        
        $paginator = $this->get('knp_paginator');


        $pagination = $paginator->paginate(
            $query,
            $request->query->getInt('page', 1),
            10
        );

        return $this->render("AppBundle:Game:index.html.twig",array(
            'pagination' => $pagination,
            "games"=>$games
        ));
    }

    public function api_allAction(Request $request,$token)
    {
        if ($token!=$this->container->getParameter('token_app')) {
            throw new NotFoundHttpException("Page not found");  
        }
        $em=$this->getDoctrine()->getManager();

        $imagineCacheManager = $this->get('liip_imagine.cache.manager');
        $list=array();
        $games =   $em->getRepository("AppBundle:Game")->findBy(array(), array("position"=>"asc"));
        foreach ($games as $key => $game) {
            $s["id"]=$game->getId();
            $s["title"]=$game->getTitle();
            $s["url"]=$game->getUrl();
            $list[]=$s;
        }
        header('Content-Type: application/json'); 
        $encoders = array(new XmlEncoder(), new JsonEncoder());
        $normalizers = array(new ObjectNormalizer());
        $serializer = new Serializer($normalizers, $encoders);
        $jsonContent=$serializer->serialize($list, 'json');
        return new Response($jsonContent);
    }
    public function api_by_sectionAction(Request $request,$id,$token)
    {
        if ($token!=$this->container->getParameter('token_app')) {
            throw new NotFoundHttpException("Page not found");  
        }
        $em=$this->getDoctrine()->getManager();
        // $section=$em->getRepository("AppBundle:Section")->find($id);

        $imagineCacheManager = $this->get('liip_imagine.cache.manager');
        $list=array();
        $games =   $em->getRepository("AppBundle:Game")->findBy(array(), array("position"=>"asc"));
        foreach ($games as $key => $game) {
            $s["id"]=$game->getId();
            $s["title"]=$game->getTitle();
            $s["url"]=$game->getUrl();
            $list[]=$s;
        }
        header('Content-Type: application/json'); 
        $encoders = array(new XmlEncoder(), new JsonEncoder());
        $normalizers = array(new ObjectNormalizer());
        $serializer = new Serializer($normalizers, $encoders);
        $jsonContent=$serializer->serialize($list, 'json');
        return new Response($jsonContent);
    }
    
    public function addAction(Request $request)
    {
        $game = new Game();
        $form = $this->createForm(GameType::class,$game);
        $em=$this->getDoctrine()->getManager();
        $form->handleRequest($request);
        // if ($form->isSubmitted() && $form->isValid()) {

        if ($form->isSubmitted()) {
            if ($game->getTitle() == null || $game->getTitle() == "") {
                $this->addFlash('warning', 'Sorry, Please Select Game');
                return $this->redirect($this->generateUrl('app_game_add'));
            } else {
                $idStr = $game->getTitle();
                $ids = explode(",", $idStr);

                for ($i = 0; $i < count($ids); $i ++) {
                    $temp_game= new Game();
                    $each_game = $this->getGameById($ids[$i]);
                    $max=0;
                    $games=$em->getRepository('AppBundle:Game')->findAll();
                    foreach ($games as $key => $value) {
                        if ($value->getPosition()>$max) {
                            $max=$value->getPosition();
                        }
                    }

                    $temp_game->setPosition($max+1);
                    $temp_game->setTitle($each_game[0]->name);

                    $replacedStr = str_replace("{width}x{height}", "500x500", $each_game[0]->box_art_url);
                    $each_game[0]->box_art_url = $replacedStr;
                    $temp_game->setUrl($each_game[0]->box_art_url);

                    $em->persist($temp_game);
                    $em->flush();
                }
                $this->addFlash('success', 'Operation has been done successfully');
                return $this->redirect($this->generateUrl('app_game_index'));
            }
        } else {
            $q = $request->query->get("q");

            $url = 'https://api.twitch.tv/helix/games/top?';
            $first = 20;

            $headers = array(
                'Content-Type: application/json',
                'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
                'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
            );

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url.'first='.$first);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_HEADER, 0);
            $body = '{}';
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
            curl_setopt($ch, CURLOPT_POSTFIELDS,$body);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            
            $result = curl_exec($ch);
            
            if ($result === FALSE) {
                die('Curl failed: ' . curl_error($ch));
            }

            $result_list = json_decode($result);
            if ($q != null || $q != "")  {
                $game_list = [];

                for ($j = 0; $j < count($result_list->data); $j ++) {
                    if(strpos($result_list->data[$j]->name, $q) !== false || $result_list->data[$j]->id == $q) {
                        $game_list[] = $result_list->data[$j];
                    }
                }

                for ($i = 0; $i < count($game_list); $i ++) {
                    $replacedStr = str_replace("{width}x{height}", "50x50", $game_list[$i]->box_art_url);
                    $game_list[$i]->box_art_url = $replacedStr;
                }
            } else {
                $game_list = [];

                for ($i = 0; $i < count($result_list->data); $i ++) {
                    $replacedStr = str_replace("{width}x{height}", "50x50", $result_list->data[$i]->box_art_url);
                    $result_list->data[$i]->box_art_url = $replacedStr;
                }

                $game_list = $result_list->data;
            }

            curl_close($ch);
        }

        return $this->render("AppBundle:Game:add.html.twig",array("game_list" => $game_list, "form"=>$form->createView()));
    }

    private function getGameById($id) {
        $url = 'https://api.twitch.tv/helix/games?';
        $headers = array(
            'Content-Type: application/json',
            'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url.'id='.$id);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        $body = '{}';
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
        curl_setopt($ch, CURLOPT_POSTFIELDS,$body);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $result = curl_exec($ch);
        
        if ($result === FALSE) {
            die('Curl failed: ' . curl_error($ch));
        }

        $game = json_decode($result)->data;

        return $game;
    }

    public function deleteAction($id,Request $request){
        $em=$this->getDoctrine()->getManager();

        $game = $em->getRepository("AppBundle:Game")->find($id);
        if($game==null){
            throw new NotFoundHttpException("Page not found");
        }

        $form=$this->createFormBuilder(array('id' => $id))
            ->add('id', HiddenType::class)
            ->add('Yes', SubmitType::class)
            ->getForm();
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()) {
            $games=$em->getRepository('AppBundle:Game')->findBy(array(),array("position"=>"asc"));
            $em->remove($game);
            $em->flush();

            $p=1;
            foreach ($games as $key => $value) {
                $value->setPosition($p); 
                $p++; 
            }
            $em->flush();
            $this->addFlash('success', 'Operation has been done successfully');
            return $this->redirect($this->generateUrl('app_game_index'));
        }
        return $this->render('AppBundle:Game:delete.html.twig',array("form"=>$form->createView()));
    }
    public function editAction(Request $request,$id)
    {
        $em=$this->getDoctrine()->getManager();
        $game=$em->getRepository("AppBundle:Game")->find($id);
        if ($game==null) {
            throw new NotFoundHttpException("Page not found");
        }
        $form = $this->createForm(GameType::class,$game);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em->persist($game);
            $em->flush();
            $this->addFlash('success', 'Operation has been done successfully');
            return $this->redirect($this->generateUrl('app_game_index'));
 
        }
        return $this->render("AppBundle:Game:edit.html.twig",array("game"=>$game,"form"=>$form->createView()));
    }
}
?>