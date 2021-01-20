<?php

namespace AppBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;
use Doctrine\Common\Collections\ArrayCollection;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use MediaBundle\Entity\Media;
/**
 * Feature
 *
 * @ORM\Table(name="feature_table")
 * @ORM\Entity(repositoryClass="AppBundle\Repository\FeatureRepository")
 */
class Feature
{
   
    /**
     * @var int
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    private $id;
    /**
     * @var string
     * @Assert\NotBlank()
     * @Assert\Length(
     *      min = 3,
     *      max = 25,
     * )
     * @ORM\Column(name="name", type="string", length=255))
     */
    private $name;

    /**
     * @var string
     * @Assert\NotBlank()
     * @Assert\Length(
     *      min = 3,
     *      max = 25,
     * )
     * @ORM\Column(name="url", type="string", length=255))
     */
    private $url;

    /**
     * @var int
     *
     * @ORM\Column(name="position", type="integer")
     */

    /**
     * 
     * @var \DateTime
     *
     * @ORM\Column(name="created", type="datetime")
     */
    private $created;

    /**
     * @var int
     *
     * @ORM\Column(name="position", type="integer")
     */
    private $position;

    /**
     * @var int
     *
     * @ORM\Column(name="viewer_count", type="integer")
     */
    private $viewer_count;

    /**
     * @var string
     * @Assert\NotBlank()
     * @Assert\Length(
     *      min = 3,
     *      max = 25,
     * )
     * @ORM\Column(name="video_url", type="string", length=255))
     */
    private $video_url;


    public function __construct()
    {
        $this->created= new \DateTime();
    }
    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Set name
     *
     * @param string $name
     * @return Feature
     */
    public function setName($name)
    {
        $this->name = $name;
        return $this;
    }

    /**
     * Get name
     *
     * @return string 
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Set position
     *
     * @param integer $position
     * @return Feature
     */
    public function setPosition($position)
    {
        $this->position = $position;
        
        return $this;
    }

    /**
     * Get position
     *
     * @return integer 
     */
    public function getPosition()
    {
        return $this->position;
    }

    /**
     * Set viewer_count
     *
     * @param integer $viewer_count
     * @return Feature
     */
    public function setViewerCount($viewer_count)
    {
        $this->viewer_count = $viewer_count;
        
        return $this;
    }

    /**
     * Get viewer_count
     *
     * @return integer 
     */
    public function getViewerCount()
    {
        return $this->viewer_count;
    }


    /**
     * Set url
     *
     * @param string $url
     * @return Feature
     */
    public function setUrl($url)
    {
        $this->url = $url;
        return $this;
    }

    /**
     * Get url
     *
     * @return string 
     */
    public function getUrl()
    {
        return $this->url;
    }

    /**
     * Set created
     *
     * @param \DateTime $created
     * @return Wallpaper
     */
    public function setCreated($created)
    {
        $this->created = $created;

        return $this;
    }

    /**
     * Get created
     *
     * @return \string 
     */
    public function getCreated()
    {
        return $this->created;
    }

    /**
     * Set video_url
     *
     * @param \string $video_url
     */
    public function setVideoUrl($video_url)
    {
        $this->video_url = $video_url;

        return $this;
    }

    /**
     * Get video_url
     *
     * @return \string 
     */
    public function getVideoUrl()
    {
        return $this->video_url;
    }

    public function __toString()
    {
        return $this->name;
    }
    public function getFeature()
    {
        return $this;
    }

}
