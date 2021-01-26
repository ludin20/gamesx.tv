<?php 
namespace AppBundle\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use AppBundle\Entity\Feature;
use MediaBundle\Entity\Media;
use AppBundle\Form\FeatureType;
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

class FeatureController extends Controller
{
    public function indexAction(Request $request)
    {

        $em = $this->getDoctrine()->getManager();
        $features = $em->getRepository('AppBundle:Feature')->findAll();

        $q="( 1=1 )";
        if ($request->query->has("q") and $request->query->get("q")!="") {
           $q.= " AND ( u.name like '%".$request->query->get("q")."%') ";
        }

        $dql = "SELECT u FROM AppBundle:Feature u  WHERE " .$q ." ";
        $query = $em->createQuery($dql);
        
        $paginator = $this->get('knp_paginator');

        $pagination = $paginator->paginate(
            $query,
            $request->query->getInt('page', 1),
            10
        );

        return $this->render("AppBundle:Feature:index.html.twig",array(
            'pagination' => $pagination,
            "features"=>$features
        ));
    }

    public function addAction(Request $request)
    {
        $feature = new Feature();
        $form = $this->createForm(FeatureType::class,$feature);

        $em=$this->getDoctrine()->getManager();
        $form->handleRequest($request);
        // if ($form->isSubmitted() && $form->isValid()) {
        if ($form->isSubmitted()) {
            if ($feature->getName() == null || $feature->getName() == "") {
                $this->addFlash('warning', 'Sorry, Please Select Feature');
                return $this->redirect($this->generateUrl('app_feature_add'));
            } else {
                $dataStr = $feature->getName();
                $dataArr = json_decode($dataStr, true);

                for ($i = 0; $i < count($dataArr); $i ++) {
                    $temp_feature= new Feature();
                    $each_feature = $this->getUserById($dataArr[$i]["id"]);
                    $max=0;
                    $features=$em->getRepository('AppBundle:Feature')->findAll();
                    foreach ($features as $key => $value) {
                        if ($value->getPosition()>$max) {
                            $max=$value->getPosition();
                        }
                    }

                    $temp_feature->setPosition($max+1);
                    $temp_feature->setName($each_feature[0]->display_name);
                    $temp_feature->setUrl($each_feature[0]->profile_image_url);
                    $temp_feature->setViewerCount($each_feature[0]->view_count);
                    $temp_feature->setVideoUrl($dataArr[$i]["video_url"]);
                    $temp_feature->setThumbnail($dataArr[$i]["thumbnail"]);

                    $em->persist($temp_feature);
                    $em->flush();
                }
                $this->addFlash('success', 'Operation has been done successfully');
                return $this->redirect($this->generateUrl('app_feature_index'));
            }
        } else {
            $q = $request->query->get("q");

            $url = 'https://api.twitch.tv/helix/streams';

            $headers = array(
                'Content-Type: application/json',
                'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
                'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
            );

            $result_list = $this->curlRequestModule($url, $headers);
            $stream_list = [];
            for ($i = 0; $i < count($result_list->data); $i ++) {
                if ($result_list->data[$i]->type == "live") {
                    $stream_list[] = $result_list->data[$i];
                }
            }

            $feature_list = [];
            if ($q != null || $q != "")  {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $feature = $this->getUserById($stream_list[$j]->user_id);
                    $stream = $this->getLiveStreamByGame($stream_list[$j]->game_name);

                    // $replacedStr = str_replace("{width}x{height}", "500x500", $stream->preview->template);
                    $replacedStr = str_replace("{width}x{height}", "500x500", $stream_list[$j]->thumbnail_url);

                    $feature[0]->video_url = $stream->channel->url;
                    $feature[0]->thumbnail = $replacedStr;
                    
                    if (strpos($feature[0]->display_name, $q) !== false || $feature[0]->id == $q) {
                        $feature_list[] = $feature[0];
                    }
                }
            } else {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $feature = $this->getUserById($stream_list[$j]->user_id);
                    $stream = $this->getLiveStreamByGame($stream_list[$j]->game_name);
                    
                    // $replacedStr = str_replace("{width}x{height}", "500x500", $stream->preview->template);
                    $replacedStr = str_replace("{width}x{height}", "500x500", $stream_list[$j]->thumbnail_url);

                    $feature[0]->video_url = $stream->channel->url;
                    $feature[0]->thumbnail = $replacedStr;
                    
                    $feature_list[] = $feature[0];
                }
            }

            curl_close($ch);
        }

        return $this->render("AppBundle:Feature:add.html.twig",array("feature_list" => $feature_list, "form"=>$form->createView()));
    }

    private function getUserById($id) {
        $url = 'https://api.twitch.tv/helix/users?';
        $headers = array(
            'Content-Type: application/json',
            'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $param = 'id='.$id;

        $result = $this->curlRequestModule($url, $headers, $param);
        $user = $result->data;

        return $user;
    }

    private function getLiveStreamByGame($game) {
        $url = 'https://api.twitch.tv/kraken/streams/?';
        $headers = array(
            'Accept: application/vnd.twitchtv.v5+json',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $param = 'game='.urlencode($game).'&sort=view';

        $result = $this->curlRequestModule($url, $headers, $param);
        $stream_list = $result->streams;

        return $stream_list[0];
    }

    private function getVideoByUserId($id) {
        $url = 'https://api.twitch.tv/helix/videos?';
        $headers = array(
            'Content-Type: application/json',
            'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $param = 'user_id='.$id.'&sort=views';

        $result = $this->curlRequestModule($url, $headers, $param);
        $video = $result->video;
        
        return $video[0];
    }

    private function curlRequestModule($url, $headers, $param = '') {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url.$param);
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

        return json_decode($result);
    }

    public function deleteAction($id,Request $request){
        $em=$this->getDoctrine()->getManager();

        $feature = $em->getRepository("AppBundle:Feature")->find($id);
        if($feature==null){
            throw new NotFoundHttpException("Page not found");
        }

        $form=$this->createFormBuilder(array('id' => $id))
            ->add('id', HiddenType::class)
            ->add('Yes', SubmitType::class)
            ->getForm();
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()) {
            $features=$em->getRepository('AppBundle:Feature')->findBy(array(),array("position"=>"asc"));
            $em->remove($feature);
            $em->flush();

            $p=1;
            foreach ($features as $key => $value) {
                $value->setPosition($p); 
                $p++; 
            }
            $em->flush();
            $this->addFlash('success', 'Operation has been done successfully');
            return $this->redirect($this->generateUrl('app_feature_index'));
        }
        return $this->render('AppBundle:Feature:delete.html.twig',array("form"=>$form->createView()));
    }
}
?>