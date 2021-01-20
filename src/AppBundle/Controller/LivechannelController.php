<?php 
namespace AppBundle\Controller;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use AppBundle\Entity\Livechannel;
use MediaBundle\Entity\Media;
use AppBundle\Form\LivechannelType;
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

class LivechannelController extends Controller
{
    public function indexAction(Request $request)
    {
        $em = $this->getDoctrine()->getManager();
        $livechannels=$em->getRepository('AppBundle:Livechannel')->findAll();

        $q="( 1=1 )";
        if ($request->query->has("q") and $request->query->get("q")!="") {
           $q.= " AND ( u.name like '%".$request->query->get("q")."%') ";
        }

        $dql = "SELECT u FROM AppBundle:Livechannel u  WHERE " .$q ." ";
        $query = $em->createQuery($dql);
        
        $paginator = $this->get('knp_paginator');

        $pagination = $paginator->paginate(
            $query,
            $request->query->getInt('page', 1),
            10
        );

        return $this->render("AppBundle:Livechannel:index.html.twig",array(
            'pagination' => $pagination,
            "livechannels"=>$livechannels
        ));
    }

    public function addAction(Request $request)
    {
        $livechannel = new Livechannel();
        $form = $this->createForm(LivechannelType::class,$livechannel);

        $em=$this->getDoctrine()->getManager();
        $form->handleRequest($request);

        if ($form->isSubmitted()) {
            if ($livechannel->getName() == null || $livechannel->getName() == "") {
                $this->addFlash('warning', 'Sorry, Please Select Livechannel');
                return $this->redirect($this->generateUrl('app_livechannel_add'));
            } else {
                $dataStr = $livechannel->getName();
                $dataArr = explode(",", $dataStr);
                
                for ($i = 0; $i < count($dataArr); $i ++) {
                    $temp_channel= new Livechannel();
                    $each_channel = $this->getChannelById($dataArr[$i]);
                    
                    $max=0;
                    $livechannels=$em->getRepository('AppBundle:Livechannel')->findAll();
                    foreach ($livechannels as $key => $value) {
                        if ($value->getPosition()>$max) {
                            $max=$value->getPosition();
                        }
                    }

                    $temp_channel->setPosition($max+1);
                    $temp_channel->setName($each_channel->name);
                    
                    $temp_channel->setDescription($each_channel->description);
                    $temp_channel->setUrl($each_channel->profile_banner);
                    $temp_channel->setVideoUrl($each_channel->url);

                    $em->persist($temp_channel);
                    $em->flush();
                }
                $this->addFlash('success', 'Operation has been done successfully');
                return $this->redirect($this->generateUrl('app_livechannel_index'));
            }
        } else {

            $q = $request->query->get("q");

            $url = 'https://api.twitch.tv/kraken/streams/';

            $headers = array(
                // 'Content-Type: application/json',
                // 'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
                'Accept: application/vnd.twitchtv.v5+json',
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
            for ($i = 0; $i < count($result_list->streams); $i ++) {
                if ($result_list->streams[$i]->stream_type == "live") {
                    $stream_list[] = $result_list->streams[$i];
                }
            }

            $livechannel_list = [];
            if ($q != null || $q != "")  {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $channel = $this->getChannelById($stream_list[$j]->channel->_id);

                    if (strpos($channel->name, $q) !== false || $channel->_id == $q) {
                        $livechannel_list[] = $channel;
                    }
                }
            } else {
                for ($j = 0; $j < count($stream_list); $j ++) {
                    $channel = $this->getChannelById($stream_list[$j]->channel->_id);
                    $livechannel_list[] = $channel;
                }
            }

            curl_close($ch);
        }

        return $this->render("AppBundle:Livechannel:add.html.twig",array("livechannel_list" => $livechannel_list, "form"=>$form->createView()));
    }

    private function getChannelById($id) {
        $url = 'https://api.twitch.tv/kraken/channels/';
        $headers = array(
            'Accept: application/vnd.twitchtv.v5+json',
            'Authorization: Bearer yyv0kg2yopv5x91lrwmyfttw0pmdk8',
            'Client-Id: jhch4uoxcoh2d4wc77joe05ff6q8vz'
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url.$id);
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

        $livechannel = json_decode($result);

        return $livechannel;
    }

    public function deleteAction($id,Request $request){
        $em=$this->getDoctrine()->getManager();

        $livechannel = $em->getRepository("AppBundle:Livechannel")->find($id);
        if($livechannel==null){
            throw new NotFoundHttpException("Page not found");
        }

        $form=$this->createFormBuilder(array('id' => $id))
            ->add('id', HiddenType::class)
            ->add('Yes', SubmitType::class)
            ->getForm();
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()) {
            $livechannels=$em->getRepository('AppBundle:Livechannel')->findBy(array(),array("position"=>"asc"));
            $em->remove($livechannel);
            $em->flush();

            $p=1;
            foreach ($livechannels as $key => $value) {
                $value->setPosition($p); 
                $p++; 
            }
            $em->flush();
            $this->addFlash('success', 'Operation has been done successfully');
            return $this->redirect($this->generateUrl('app_livechannel_index'));
        }
        return $this->render('AppBundle:Livechannel:delete.html.twig',array("form"=>$form->createView()));
    }
}
?>