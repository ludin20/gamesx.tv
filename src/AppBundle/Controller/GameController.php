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
        $games=$em->getRepository('AppBundle:Game')->findAll();

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
                $dataStr = $game->getTitle();
                $dataArr = json_decode($dataStr, true);

                for ($i = 0; $i < count($dataArr); $i ++) {
                    $temp_game= new Game();
                    $each_game = $this->getGameById($dataArr[$i]["id"]);
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
                    
                    $temp_game->setDescription($dataArr[$i]["description"]);
                    $temp_game->setLanguage($dataArr[$i]["language"]);
                    $temp_game->setVideoUrl($dataArr[$i]["video_url"]);
                    $temp_game->setViewerCount((int)$dataArr[$i]["viewer_count"]);

                    $em->persist($temp_game);
                    $em->flush();
                }
                $this->addFlash('success', 'Operation has been done successfully');
                return $this->redirect($this->generateUrl('app_game_index'));
            }
        } else {
            $q = $request->query->get("q");

            $url = 'https://api.twitch.tv/helix/streams';

            $headers = array(
                'Content-Type: application/json',
                'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
                'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
            );

            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
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

            $stream_list = [];
            for ($i = 0; $i < count($result_list->data); $i ++) {
                if ($result_list->data[$i]->type == "live") {
                    $stream_list[] = $result_list->data[$i];
                }
            }

            $game_list = [];
            if ($q != null || $q != "")  {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $game = $this->getGameById($stream_list[$j]->game_id);
                    $video = $this->getVideoByGameId($stream_list[$j]->game_id);

                    if (strpos($game[0]->name, $q) !== false || $game[0]->id == $q) {
                        $replacedStr = str_replace("{width}x{height}", "50x50", $game[0]->box_art_url);
                        $game[0]->box_art_url = $replacedStr;
                        $game[0]->viewer_count = $stream_list[$j]->viewer_count;
                        $game[0]->description = $stream_list[$j]->title;
                        $game[0]->language = $stream_list[$j]->language;
                        $game[0]->video_url = $video->url;
                        $game_list[] = $game[0];
                    }
                }

                for ($i = 0; $i < count($game_list); $i ++) {
                    $replacedStr = str_replace("{width}x{height}", "50x50", $game_list[$i]->box_art_url);
                    $game_list[$i]->box_art_url = $replacedStr;
                }
            } else {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $game = $this->getGameById($stream_list[$j]->game_id);
                    $video = $this->getVideoByGameId($stream_list[$j]->game_id);
                    
                    $replacedStr = str_replace("{width}x{height}", "50x50", $game[0]->box_art_url);
                    $game[0]->box_art_url = $replacedStr;
                    $game[0]->viewer_count = $stream_list[$j]->viewer_count;
                    $game[0]->description = $stream_list[$j]->title;
                    $game[0]->language = $stream_list[$j]->language;
                    $game[0]->video_url = $video->url;
                    $game_list[] = $game[0];
                }
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

    private function getVideoByGameId($id) {
        $url = 'https://api.twitch.tv/helix/videos?';
        $headers = array(
            'Content-Type: application/json',
            'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url.'game_id='.$id.'&sort=views');
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

        $video = json_decode($result)->data;
        return $video[0];
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
}
?>